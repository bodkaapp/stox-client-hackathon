import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:holiday_jp/holiday_jp.dart' as holiday_jp;
import '../widgets/date_header_widget.dart';
import '../../config/app_colors.dart';
import '../../config/food_events.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/recipe.dart';
import '../../infrastructure/repositories/drift_recipe_repository.dart';
import '../../infrastructure/repositories/drift_meal_plan_repository.dart';
import '../widgets/calendar/weekly_calendar_strip.dart';
import '../widgets/calendar/monthly_calendar_view.dart';
import 'recipe_webview_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/search_modal.dart';
import 'cooking_mode_screen.dart';
import 'food_camera_screen.dart';
import 'recipe_search_results_screen.dart';
import 'photo_viewer_screen.dart';
import '../widgets/help_icon.dart';
import '../../domain/models/challenge_stamp.dart';
import '../viewmodels/challenge_stamp_viewmodel.dart';
import '../widgets/challenge_stamp/congratulation_dialog.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../mixins/ad_manager_mixin.dart';
import 'ai_menu_proposal_loading_screen.dart';
import '../components/ai_suggestion_button.dart';
import '../../l10n/generated/app_localizations.dart';


// -----------------------------------------------------------------------------
// Models
// -----------------------------------------------------------------------------

class MealPlanWithRecipe {
  final MealPlan mealPlan;
  final Recipe? recipe;

  MealPlanWithRecipe({required this.mealPlan, this.recipe});
}

// -----------------------------------------------------------------------------
// Providers
// -----------------------------------------------------------------------------

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final dailyMealPlanProvider = StreamProvider.autoDispose.family<List<MealPlanWithRecipe>, DateTime>((ref, date) async* {
  final mealPlanRepo = await ref.watch(mealPlanRepositoryProvider.future);
  final recipeRepo = await ref.watch(recipeRepositoryProvider.future);

  yield* mealPlanRepo.watchByDate(date).asyncMap((mealPlans) async {
    final results = <MealPlanWithRecipe>[];
    for (final plan in mealPlans) {
      final recipe = await recipeRepo.getById(plan.recipeId);
      results.add(MealPlanWithRecipe(mealPlan: plan, recipe: recipe));
    }
    return results;
  });
});


// -----------------------------------------------------------------------------
// Screen
// -----------------------------------------------------------------------------

class MenuPlanScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final bool showBackButton;
  const MenuPlanScreen({super.key, this.initialDate, this.showBackButton = false});

  @override
  ConsumerState<MenuPlanScreen> createState() => _MenuPlanScreenState();
}

class _MenuPlanScreenState extends ConsumerState<MenuPlanScreen> with AdManagerMixin {
  late ScrollController _dateScrollController;
  bool _isMonthlyView = false;
  DateTime _focusedMonth = DateTime.now();
  final GlobalKey _returnToTodayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ja');
    _dateScrollController = ScrollController();
    loadRewardedAd(); // Load Ad on Init
    
    if (widget.initialDate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedDateProvider.notifier).state = widget.initialDate!;
      });
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dateScrollController.hasClients) {
        // Simple centering logic could be added here if needed
      }
    });
  }

  @override
  void didUpdateWidget(MenuPlanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != null && widget.initialDate != oldWidget.initialDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedDateProvider.notifier).state = widget.initialDate!;
      });
    }
  }

  @override
  void dispose() {
    _dateScrollController.dispose();
    disposeAd();
    super.dispose();
  }

  void _showSpeechBubble(BuildContext context) {
    final renderBox = _returnToTodayKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
             onTap: () => entry.remove(),
             behavior: HitTestBehavior.translucent,
             child: Container(color: Colors.transparent),
          ),
          Positioned(
            top: offset.dy + size.height + 8,
            right: MediaQuery.of(context).size.width - (offset.dx + size.width) - 10,
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: CustomPaint(
                      painter: _TrianglePainter(color: const Color(0xFF4B5563)),
                      size: const Size(12, 8),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B5563),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.menuReturnToTodayDescription,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(entry);
    
    // Auto remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  bool _isSameWeek(DateTime date1, DateTime date2) {
    // Standardize to midnight to avoid time issues, though not strictly necessary for week calc if logic is robust
    final d1 = DateTime(date1.year, date1.month, date1.day);
    final d2 = DateTime(date2.year, date2.month, date2.day);
    // Find the start of the week (Sunday)
    final startOfWeek1 = d1.subtract(Duration(days: d1.weekday % 7));
    final startOfWeek2 = d2.subtract(Duration(days: d2.weekday % 7));
    return DateUtils.isSameDay(startOfWeek1, startOfWeek2);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final mealPlansAsync = ref.watch(dailyMealPlanProvider(selectedDate));

    // Listen for Challenge Completion Events
    ref.listen<ChallengeType?>(challengeCompletionEventProvider, (previous, next) {
      if (next != null) {
        CongratulationDialog.show(context, next);
        // Reset event is handled by provider override or state update logic if needed, 
        // but since provider is state provider, next set will be new state.
        // Ideally we consume it.
        // For simplicity with StateProvider, we can leave it or set it back to null if we want to re-trigger same event (unlikely for stamps).
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDFA).withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.stoxPrimary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.calendar_month, color: AppColors.stoxPrimary, size: 22),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.menuPlanTitle, // 献立計画表
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.stoxText, height: 1.0),
                ),
                const Text(
                  'MENU PLAN',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxAccent, letterSpacing: 1.0),
                ),
              ],
            ),
            const SizedBox(width: 8),
            HelpIcon(
              title: AppLocalizations.of(context)!.menuPlanHelpTitle, // 献立計画表画面
              description: AppLocalizations.of(context)!.menuPlanHelpDescription, // これから作る料理の献立を計画したり、前に作った料理のレシピを振り返ったりする画面です。
            ),
          ],
        ),
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF57534E)),
                onPressed: () => context.go('/photo_gallery'),
              )
            : (Navigator.canPop(context)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF57534E)),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null),
        actions: [
          Builder(
            builder: (context) {
              final isDifferentWeek = !_isSameWeek(selectedDate, DateTime.now());
              final color = isDifferentWeek ? AppColors.stoxPrimary : Colors.grey[400];
              return IconButton(
                key: _returnToTodayKey,
                onPressed: () {
                  if (isDifferentWeek) {
                    ref.read(selectedDateProvider.notifier).state = DateTime.now();
                  } else {
                    _showSpeechBubble(context);
                  }
                },
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                     Icon(Icons.calendar_today, color: color),
                     Padding(
                       padding: const EdgeInsets.only(top: 5),
                       child: Text(
                         DateTime.now().day.toString(),
                         style: TextStyle(
                           fontSize: 10,
                           fontWeight: FontWeight.w900,
                           color: color,
                         ),
                       ),
                     ),
                  ],
                ),
                tooltip: isDifferentWeek ? AppLocalizations.of(context)!.menuReturnToToday : null,
              );
            }
          ),
          LayoutBuilder(
            builder: (context, constraints) {
               final isTablet = MediaQuery.of(context).size.width >= 600;
               if (!isTablet) {
                 return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isMonthlyView = !_isMonthlyView;
                        });
                      },
                      icon: const Icon(Icons.calendar_month, color: Color(0xFF57534E)),
                      style: IconButton.styleFrom(
                        backgroundColor: _isMonthlyView ? AppColors.stoxPrimary.withOpacity(0.1) : const Color(0xFFF5F5F4),
                      ),
                    ),
                  );
               }
               return const SizedBox.shrink();
            }
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return _buildTabletLayout(selectedDate, mealPlansAsync);
          }
          return _buildMobileLayout(selectedDate, mealPlansAsync);
        },
      ),
    );
  }

  Widget _buildMobileLayout(DateTime selectedDate, AsyncValue<List<MealPlanWithRecipe>> mealPlansAsync) {
    return Column(
      children: [
        _isMonthlyView 
          ? MonthlyCalendarView(
              selectedDate: selectedDate,
              focusedMonth: _focusedMonth,
              onDateSelected: (date) {
                ref.read(selectedDateProvider.notifier).state = date;
              },
              onPageChanged: (date) {
                setState(() {
                  _focusedMonth = date;
                });
              },
            )
          : WeeklyCalendarStrip(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                ref.read(selectedDateProvider.notifier).state = date;
              },
              scrollController: _dateScrollController,
            ),
        
        const Divider(height: 1, color: Color(0xFFF5F5F4)),

        Expanded(
          child: mealPlansAsync.when(
            data: (data) => _buildMealSections(data, selectedDate),
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(DateTime selectedDate, AsyncValue<List<MealPlanWithRecipe>> mealPlansAsync) {
     return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 360,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(right: BorderSide(color: Color(0xFFF5F5F4))),
          ),
          child: Column(
            children: [
               Expanded(
                 child: SingleChildScrollView(
                   child: Padding(
                     padding: const EdgeInsets.only(top: 16.0),
                     child: MonthlyCalendarView(
                        selectedDate: selectedDate,
                        focusedMonth: _focusedMonth,
                        onDateSelected: (date) {
                          ref.read(selectedDateProvider.notifier).state = date;
                        },
                        onPageChanged: (date) {
                          setState(() {
                            _focusedMonth = date;
                          });
                        },
                      ),
                   ),
                 ),
               ),
            ],
          ),
        ),

        Expanded(
          child: mealPlansAsync.when(
            data: (data) => _buildMealSections(data, selectedDate),
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }

  // _buildDateHeader removed


  Widget _buildMealSections(List<MealPlanWithRecipe> plans, DateTime selectedDate) {
    final breakfast = plans.where((p) => p.mealPlan.mealType == MealType.breakfast).toList();
    final lunch = plans.where((p) => p.mealPlan.mealType == MealType.lunch).toList();
    final dinner = plans.where((p) => p.mealPlan.mealType == MealType.dinner).toList();
    final preMade = plans.where((p) => p.mealPlan.mealType == MealType.preMade).toList();
    final undecided = plans.where((p) => p.mealPlan.mealType == MealType.undecided).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      children: [
        DateHeaderWidget(
          date: selectedDate,
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: 12),
        _buildSection(
          title: AppLocalizations.of(context)!.menuBreakfast, // 朝食
          label: AppLocalizations.of(context)!.menuBreakfastLabel, // 朝
          color: const Color(0xFFFBBF24),
          bgColor: const Color(0xFFFEF3C7),
          textColor: const Color(0xFFB45309),
          items: breakfast,
          isHorizontal: false,
          type: MealType.breakfast,
          selectedDate: selectedDate,
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: AppLocalizations.of(context)!.menuLunch, // 昼食
          label: AppLocalizations.of(context)!.menuLunchLabel, // 昼
          color: const Color(0xFFFB923C),
          bgColor: const Color(0xFFFFEDD5),
          textColor: const Color(0xFFC2410C),
          items: lunch,
          isHorizontal: false, 
          type: MealType.lunch,
          selectedDate: selectedDate,
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: AppLocalizations.of(context)!.menuDinner, // 夕食
          label: AppLocalizations.of(context)!.menuDinnerLabel, // 夜
          color: const Color(0xFFFB7185),
          bgColor: const Color(0xFFFFE4E6),
          textColor: const Color(0xFFBE123C),
          items: dinner,
          isHorizontal: false,
          type: MealType.dinner,
          selectedDate: selectedDate,
        ),
        const SizedBox(height: 24),
        _buildPreMadeSection(
          items: preMade,
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: AppLocalizations.of(context)!.menuUndecided, // 時間未定
          label: AppLocalizations.of(context)!.menuUndecidedLabel, // 未定
          color: const Color(0xFF9CA3AF),
          bgColor: const Color(0xFFF3F4F6),
          textColor: const Color(0xFF4B5563),
          items: undecided,
          isHorizontal: false,
          type: MealType.undecided,
          selectedDate: selectedDate,
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String label,
    required Color color,
    required Color bgColor,
    required Color textColor,
    required List<MealPlanWithRecipe> items,
    required bool isHorizontal,
    required MealType type,
    required DateTime selectedDate,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final isPast = targetDate.isBefore(today);
    final isToday = targetDate.isAtSameMomentAs(today);

    // Text Logic
    final String emptyStateText = isPast 
        ? AppLocalizations.of(context)!.menuNoMenu // 献立はありません
        : AppLocalizations.of(context)!.menuNoPlan; // 予定はありません

    // Button Visibility Logic
    bool showAiButton = false;
    
    if (!isPast) {
      if (!isToday) {
        // Future: Always show
        showAiButton = true;
      } else {
        // Today: Check time limits
        switch (type) {
          case MealType.breakfast:
            showAiButton = now.hour < 11; // Until 11:00
            break;
          case MealType.lunch:
            showAiButton = now.hour < 15; // Until 15:00
            break;
          case MealType.dinner:
            showAiButton = now.hour < 21; // Until 21:00
            break;
          default:
            // For others (Undecided, Snack etc.), keep shown for today
            showAiButton = true; 
            break;
        }
      }
    }
    // Specific override: If type is 'preMade', we might generally want to show it or logic handled in _buildPreMadeSection? 
    // _buildSection is seemingly for B/L/D/Undecided. PreMade uses _buildPreMadeSection.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                    if (items.any((e) => e.recipe != null)) ...[
                     TextButton.icon(
                      onPressed: () => _onMadeIt(items),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: Text(AppLocalizations.of(context)!.menuMade, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // 作った
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF78716C),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 4),
                     if (items.any((e) => e.recipe != null && e.recipe!.pageUrl.isNotEmpty))
                       TextButton.icon(
                        onPressed: () => _onCook(items),
                        icon: const Icon(Icons.restaurant_menu, size: 16),
                        label: Text(AppLocalizations.of(context)!.menuCook, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // 料理する
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.stoxPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                   ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
           Container(
             width: double.infinity,
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE7E5E4)),
             ),
             child: Column(
               children: [
                 Text(emptyStateText, style: const TextStyle(fontSize: 12, color: Color(0xFFA8A29E))),
                 if (showAiButton && type != MealType.undecided) ...[
                   const SizedBox(height: 12),
                   SizedBox(
                     width: double.infinity,
                     child: AiSuggestionButton(
                       onTap: () => _onAskAi(type),
                       label: AppLocalizations.of(context)!.menuAskAi, // AIに献立を提案してもらう
                     ),
                   ),
                 ],
               ],
             ),
           )
        else if (isHorizontal)
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _buildHorizontalCard(items[index]);
              },
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildVerticalCard(items[index]);
            },
          ),
          
        if (items.any((e) => e.mealPlan.photos.isNotEmpty))
           Container(
             height: 100,
             margin: const EdgeInsets.only(top: 12),
             child: ListView(
               scrollDirection: Axis.horizontal,
               children: items.expand((e) => e.mealPlan.photos).map((path) {
                 return Padding(
                   padding: const EdgeInsets.only(right: 8),
                   child: GestureDetector(
                     onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => PhotoViewerScreen(filePath: path),
                          ),
                        );
                     },
                     child: Stack(
                       children: [
                         ClipRRect(
                           borderRadius: BorderRadius.circular(8),
                           child: Image.file(File(path), width: 100, height: 100, fit: BoxFit.cover),
                         ),
                       Positioned(
                         bottom: 4,
                         right: 4,
                         child: FutureBuilder<DateTime>(
                           future: File(path).lastModified(),
                           builder: (context, snapshot) {
                             if (!snapshot.hasData) return const SizedBox.shrink();
                             return Container(
                               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                               decoration: BoxDecoration(
                                 color: Colors.black.withOpacity(0.6),
                                 borderRadius: BorderRadius.circular(4),
                               ),
                               child: Text(
                                 DateFormat('HH:mm').format(snapshot.data!),
                                 style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                               ),
                             );
                           },
                         ),
                       ),
                     ],
                   ),
                  ),
                 );
               }).toList(),
             ),
           ),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton.icon(
              onPressed: () => _onAddDish(type),
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: Text(AppLocalizations.of(context)!.menuAddDish, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // 料理を追加する
              style: TextButton.styleFrom(
                foregroundColor: AppColors.stoxPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildPreMadeSection({required List<MealPlanWithRecipe> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Row(
                 children: [
                   Container(
                     width: 4,
                     height: 20,
                     decoration: BoxDecoration(
                       color: const Color(0xFF2DD4BF),
                       borderRadius: BorderRadius.circular(2),
                     ),
                   ),
                   const SizedBox(width: 8),
                   Text(
                     AppLocalizations.of(context)!.menuMealPrep, // 作り置き
                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                   ),
                   const SizedBox(width: 8),
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                     decoration: BoxDecoration(
                       color: const Color(0xFFCCFBF1),
                       borderRadius: BorderRadius.circular(4),
                     ),
                     child: Text(
                       AppLocalizations.of(context)!.menuMealPrepLabel, // 準備
                       style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                     ),
                   ),
                 ],
               ),
               TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: Text(AppLocalizations.of(context)!.menuAdd, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // 追加
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.stoxPrimary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
             ],
          ),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE7E5E4), style: BorderStyle.none),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.restaurant, size: 32, color: Color(0xFFD6D3D1)),
                  SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.menuMealPrepGuide, // 週末の作り置きレシピを\n登録してみましょう
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFFA8A29E)),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildVerticalCard(items[index]);
            },
          ),
      ],
    );
  }

  Widget _buildHorizontalCard(MealPlanWithRecipe item) {
    final recipe = item.recipe;
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF5F5F4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    if (recipe != null && recipe.pageUrl.isNotEmpty) {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => RecipeWebViewScreen(
                            url: recipe.pageUrl,
                            title: recipe.title,
                            imageUrl: recipe.ogpImageUrl,
                            existingRecipeId: recipe.id,
                          ),
                        ),
                      );
                    }
                  },
                  child: (recipe?.ogpImageUrl != null && recipe!.ogpImageUrl!.isNotEmpty)
                    ? Image.network(
                        recipe.ogpImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.grey)),
                      )
                    : Container(color: Colors.grey[200], child: const Icon(Icons.restaurant, color: Colors.grey)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              recipe?.title ?? 'No Title',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF292524), height: 1.2),
            ),
          ),
          if (item.mealPlan.isDone && item.mealPlan.completedAt != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Text(
                AppLocalizations.of(context)!.menuCookedAt(DateFormat('HH:mm').format(item.mealPlan.completedAt!)), // {time}に作りました
                style: const TextStyle(fontSize: 10, color: AppColors.stoxPrimary, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVerticalCard(MealPlanWithRecipe item) {
    final recipe = item.recipe;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF5F5F4)), // border-stone-100
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (recipe != null && recipe.pageUrl.isNotEmpty) {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => RecipeWebViewScreen(
                      url: recipe.pageUrl,
                      title: recipe.title,
                      imageUrl: recipe.ogpImageUrl,
                      existingRecipeId: recipe.id,
                    ),
                  ),
                );
              }
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(12),
                 color: Colors.grey[200],
              ),
              clipBehavior: Clip.antiAlias,
              child: (recipe?.ogpImageUrl != null && recipe!.ogpImageUrl!.isNotEmpty)
                    ? Image.network(
                        recipe.ogpImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                      )
                    : const Icon(Icons.restaurant, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  recipe?.title ?? 'No Title',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF292524), height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.mealPlan.isDone && item.mealPlan.completedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.menuCookedAt(DateFormat('HH:mm').format(item.mealPlan.completedAt!)), // {time}に作りました
                    style: const TextStyle(fontSize: 12, color: AppColors.stoxPrimary, fontWeight: FontWeight.bold),
                  ),
                ],
                const SizedBox(height: 4),
                 if (recipe != null)
                 const Row(
                   children: [
                      // Example tag
                   ],
                 )
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _onAskAi(MealType type) async {
    final result = await showAdAndExecute(
      context: context,
      preAdTitle: AppLocalizations.of(context)!.menuAiProposalTitle, // AI献立提案
      preAdContent: AppLocalizations.of(context)!.menuAiProposalMessage, // 広告を視聴して、AIに献立を提案してもらいますか？\n（今の冷蔵庫の中身や前後の食事バランスを考慮します）
      confirmButtonText: AppLocalizations.of(context)!.menuAiProposalAction, // 広告を見て提案してもらう
    );

    if (result && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AiMenuProposalLoadingScreen(
            targetDate: ref.read(selectedDateProvider),
            mealType: type,
          ),
        ),
      );
    }
  }

  void _onMadeIt(List<MealPlanWithRecipe> items) {
    if (items.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.menuCookingDoneTitle), // お料理お疲れ様でした！
          content: Text(AppLocalizations.of(context)!.menuCookingDoneMessage), // もし作った料理を撮影した写真があったら、写真を貼っておくことで、後で見返すのが楽になります✨
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.actionCancel), // キャンセル
            ),
            TextButton(
              onPressed: () async {
                 Navigator.pop(context);
                 _pickAndSaveImage(items, ImageSource.gallery);
              },
              child: Text(AppLocalizations.of(context)!.menuAttachPhoto), // 撮った写真を貼る
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _openFoodCameraAndSave(items);
              },
              child: Text(AppLocalizations.of(context)!.menuTakePhoto), // 撮影する
            ),
             TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _markAsDone(items);
              },
              child: Text(AppLocalizations.of(context)!.menuCompleteWithoutPhoto), // 写真を貼らずに完了する
            ),
          ],
        );
      },
    );
  }

  Future<void> _markAsDone(List<MealPlanWithRecipe> items) async {
    if (items.isEmpty) return;
    final target = items.first;
    try {
      final repo = await ref.read(mealPlanRepositoryProvider.future);
      final updatedPlan = target.mealPlan.copyWith(
        isDone: true,
        completedAt: target.mealPlan.completedAt ?? DateTime.now(),
      );
      await repo.save(updatedPlan);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.menuSaveFailed(e)))); // 保存に失敗しました: {error}
      }
    }
  }

  Future<void> _openFoodCameraAndSave(List<MealPlanWithRecipe> items) async {
    // Navigate to FoodCameraScreen and wait for result (image path)
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const FoodCameraScreen(),
      ),
    );

    if (result != null && result is String) {
      await _saveImagesToPlan(items, [result]);
    }
  }

  Future<void> _pickAndSaveImage(List<MealPlanWithRecipe> items, ImageSource source) async {
    final picker = ImagePicker();
    List<String> newPaths = [];

    if (source == ImageSource.gallery) {
      final pickedList = await picker.pickMultiImage();
      if (pickedList.isNotEmpty) {
        newPaths = pickedList.map((e) => e.path).toList();
      }
    } else {
      final picked = await picker.pickImage(source: source);
      if (picked != null) {
        newPaths = [picked.path];
      }
    }

    if (newPaths.isEmpty) return;

    if (items.isEmpty) return;
    final targetMealPlan = items.first.mealPlan;
    
    // Duplicate Check
    final existingPaths = targetMealPlan.photos;
    final nonDuplicatePaths = <String>[];
    
    // Calculate hashes for existing photos
    final existingHashes = <String>{};
    for (final path in existingPaths) {
      try {
        final hash = await _calculateFileHash(File(path));
        if (hash != null) existingHashes.add(hash);
      } catch (e) {
        // Ignore errors for existing files
      }
    }

    int duplicateCount = 0;
    for (final path in newPaths) {
      try {
        final hash = await _calculateFileHash(File(path));
        if (hash != null && existingHashes.contains(hash)) {
          duplicateCount++;
        } else {
          // Also check against other new photos to prevent selecting same photo twice in one go selection (though picker usually handles this)
          if(hash != null) {
             existingHashes.add(hash); // Add to set to catch duplicates within selection
          }
          nonDuplicatePaths.add(path);
        }
      } catch (e) {
        // If calculation fails, assume unique (or skip? safest to add)
        nonDuplicatePaths.add(path);
      }
    }

    if (duplicateCount > 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.menuImagesSkipped(duplicateCount))), // {count} 枚の画像はすでに存在するためスキップされました
        );
      }
    }

    if (nonDuplicatePaths.isNotEmpty) {
      await _saveImagesToPlan(items, nonDuplicatePaths);
    }
  }

  Future<String?> _calculateFileHash(File file) async {
    if (!file.existsSync()) return null;
    try {
      final bytes = await file.readAsBytes();
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      debugPrint('Error calculating hash: $e');
      return null;
    }
  }

  Future<void> _saveImagesToPlan(List<MealPlanWithRecipe> items, List<String> paths) async {
    if (items.isEmpty) return;
    final target = items.first;
    try {
      final repo = await ref.read(mealPlanRepositoryProvider.future);
      final updatedPlan = target.mealPlan.copyWith(
        photos: [...target.mealPlan.photos, ...paths],
        isDone: true,
        completedAt: target.mealPlan.completedAt ?? DateTime.now(),
      );
      await repo.save(updatedPlan);
      
      // Challenge 7: Cook and Photo
      await ref.read(challengeStampViewModelProvider.notifier).complete(ChallengeType.cookAndPhoto.id);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.menuImageSaveFailed(e)))); // 画像の保存に失敗しました: {error}
      }
    }
  }

  void _onCook(List<MealPlanWithRecipe> items) {
    if (items.isEmpty) return;
    final recipe = items.first.recipe;
    
    if (recipe == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.menuNoRecipe))); // レシピがありません
      return;
    }

    if (recipe.pageUrl.isEmpty) {
       // Manual recipe -> maybe just open details or nothing?
       // Current requirement: "Cook" button shown only if URL exists (check logic in build)
       return; 
    }

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => CookingModeScreen(recipes: items.map((e) => e.recipe!).where((r) => r.pageUrl.isNotEmpty).toList()),
      ),
    );
  }

  void _onAddDish(MealType type) async {
    // When adding dish, we might want to default to currently selected date in the view
    final date = ref.read(selectedDateProvider);
    
    final intent = await SearchModal.show(context, initialDate: date, initialMealType: type);

    if (!mounted || intent == null) return;

    if (intent is UrlSearchIntent) {
      if (mounted) {
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => RecipeWebViewScreen(
              url: intent.url,
              title: AppLocalizations.of(context)!.menuLoading, // 読み込み中
              initialDate: date,
              initialMealType: type,
            ),
          ),
        );
      }
    } else if (intent is TextSearchIntent) {
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeSearchResultsScreen(
              searchQuery: intent.query,
              initialDate: date,
              initialMealType: type,
            ),
          ),
        );
      }
    }
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
