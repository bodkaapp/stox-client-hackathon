
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../config/app_colors.dart';
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

final dailyMealPlanProvider = FutureProvider.autoDispose.family<List<MealPlanWithRecipe>, DateTime>((ref, date) async {
  final mealPlanRepo = await ref.watch(mealPlanRepositoryProvider.future);
  final recipeRepo = await ref.watch(recipeRepositoryProvider.future);

  // Watch for changes on the specific date
  // Since we want reactive updates, we might want to use a StreamProvider instead, 
  // but for now, we'll simpler fetch. If we want real-time, we can change to Stream.
  // Actually, let's just use getByDateRange for the single day (start to end)
  // or match the repository method. DriftMealPlanRepository has watchByDate.
  // Let's use watchByDate logic if possible, but FutureProvider is easier for now.
  // We can use Ref.watch on a stream provider if we define one.
  
  // For simplicity:
  final startOfDay = DateTime(date.year, date.month, date.day);
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
  
  final mealPlans = await mealPlanRepo.getByDateRange(startOfDay, endOfDay);
  
  final results = <MealPlanWithRecipe>[];
  for (final plan in mealPlans) {
    final recipe = await recipeRepo.getById(plan.recipeId);
    results.add(MealPlanWithRecipe(mealPlan: plan, recipe: recipe));
  }
  return results;
});


// -----------------------------------------------------------------------------
// Screen
// -----------------------------------------------------------------------------

class MenuPlanScreen extends ConsumerStatefulWidget {
  const MenuPlanScreen({super.key});

  @override
  ConsumerState<MenuPlanScreen> createState() => _MenuPlanScreenState();
}

class _MenuPlanScreenState extends ConsumerState<MenuPlanScreen> {
  late ScrollController _dateScrollController;
  bool _isMonthlyView = false;
  DateTime _focusedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ja');
    _dateScrollController = ScrollController();
    
    // Scroll to center initially (approx)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dateScrollController.hasClients) {
        // Simple centering logic could be added here if needed
      }
    });
  }

  @override
  void dispose() {
    _dateScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final mealPlansAsync = ref.watch(dailyMealPlanProvider(selectedDate));

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFA), // bg-background-light
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDFA).withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          '献立計画表',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF292524), // text-stone-800
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF57534E)), // text-stone-600
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isMonthlyView = !_isMonthlyView;
                });
              },
              icon: const Icon(Icons.calendar_month, color: Color(0xFF57534E)),
              style: IconButton.styleFrom(
                backgroundColor: _isMonthlyView ? AppColors.stoxPrimary.withOpacity(0.1) : const Color(0xFFF5F5F4), // bg-stone-100 or active tint
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Strip or Calendar
          _isMonthlyView 
            ? MonthlyCalendarView(
                selectedDate: selectedDate,
                focusedMonth: _focusedMonth,
                onDateSelected: (date) {
                  ref.read(selectedDateProvider.notifier).state = date;
                  // Optional: switch back to week view? Or keep in month view?
                  // Keeping in month view as per standard behavior unless requested.
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

          // Main Content
          Expanded(
            child: mealPlansAsync.when(
              data: (data) => _buildMealSections(data),
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildMealSections(List<MealPlanWithRecipe> plans) {
    // Group by MealType
    final breakfast = plans.where((p) => p.mealPlan.mealType == MealType.breakfast).toList();
    final lunch = plans.where((p) => p.mealPlan.mealType == MealType.lunch).toList();
    final dinner = plans.where((p) => p.mealPlan.mealType == MealType.dinner).toList();
    final preMade = plans.where((p) => p.mealPlan.mealType == MealType.preMade).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSection(
          title: '朝食',
          label: '朝',
          color: const Color(0xFFFBBF24), // amber-400
          bgColor: const Color(0xFFFEF3C7), // amber-100
          textColor: const Color(0xFFB45309), // amber-700
          items: breakfast,
          isHorizontal: true,
          type: MealType.breakfast,
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: '昼食',
          label: '昼',
          color: const Color(0xFFFB923C), // orange-400
          bgColor: const Color(0xFFFFEDD5), // orange-100
          textColor: const Color(0xFFC2410C), // orange-700
          items: lunch,
          isHorizontal: false, // Changed from previous view but let's keep it as is if I didn't mean to change horizontal flow. Wait, previous code says isHorizontal: false for lunch/dinner.
          type: MealType.lunch,
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: '夕食',
          label: '夜',
          color: const Color(0xFFFB7185), // rose-400
          bgColor: const Color(0xFFFFE4E6), // rose-100
          textColor: const Color(0xFFBE123C), // rose-700
          items: dinner,
          isHorizontal: false,
          type: MealType.dinner,
        ),
        const SizedBox(height: 24),
        _buildPreMadeSection(
          items: preMade,
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
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
                   // Made It Button (Secondary)
                   if (items.any((e) => e.recipe != null)) ...[
                     TextButton.icon(
                      onPressed: () => _onMadeIt(items),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text('作った', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF78716C), // stone-500
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 4),
                     // Cook Button (Primary)
                     // Hide if all recipes are manual entry (empty URL)
                     if (items.any((e) => e.recipe != null && e.recipe!.pageUrl.isNotEmpty))
                       TextButton.icon(
                        onPressed: () => _onCook(items),
                        icon: const Icon(Icons.restaurant_menu, size: 16),
                        label: const Text('料理する', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.stoxPrimary, // Primary Color
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
        // Content
        if (items.isEmpty)
           Container(
             width: double.infinity,
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
                color: Colors.grey[50], // bg-stone-50
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE7E5E4)), // border-stone-200
             ),
             child: const Center(
               child: Text('予定はありません', style: TextStyle(fontSize: 12, color: Color(0xFFA8A29E))), // text-stone-400
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
          
        // Photos
        if (items.any((e) => e.mealPlan.photos.isNotEmpty))
           Container(
             height: 100,
             margin: const EdgeInsets.only(top: 12),
             child: ListView(
               scrollDirection: Axis.horizontal,
               children: items.expand((e) => e.mealPlan.photos).map((path) {
                 return Padding(
                   padding: const EdgeInsets.only(right: 8),
                   child: ClipRRect(
                     borderRadius: BorderRadius.circular(8),
                     child: Image.file(File(path), width: 100, height: 100, fit: BoxFit.cover),
                   ),
                 );
               }).toList(),
             ),
           ),

        // Add Dish Button at bottom right
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton.icon(
              onPressed: () => _onAddDish(type),
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('料理を追加する', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
                       color: const Color(0xFF2DD4BF), // teal-400
                       borderRadius: BorderRadius.circular(2),
                     ),
                   ),
                   const SizedBox(width: 8),
                   const Text(
                     '作り置き',
                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                   ),
                   const SizedBox(width: 8),
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                     decoration: BoxDecoration(
                       color: const Color(0xFFCCFBF1), // teal-100
                       borderRadius: BorderRadius.circular(4),
                     ),
                     child: const Text(
                       '準備',
                       style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)), // teal-700
                     ),
                   ),
                 ],
               ),
               TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text('追加', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
              color: const Color(0xFFF5F5F4), // bg-stone-100
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE7E5E4), style: BorderStyle.none), // dashed border hard to do with standard border, using none for now or maybe DottedBorder package if available. HTML has dashed.
            ),
            // Use CustomPaint for dashed border if strictly needed, but solid/lighter is okay for MVP.
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.restaurant, size: 32, color: Color(0xFFD6D3D1)), // stone-300
                  SizedBox(height: 8),
                  Text(
                    '週末の作り置きレシピを\n登録してみましょう',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFFA8A29E)), // stone-400
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
        border: Border.all(color: const Color(0xFFF5F5F4)), // border-stone-100
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
                const SizedBox(height: 4),
                 if (recipe != null)
                 // Mock tags or real tags if available. Recipe doesn't seem to have tags in provided model view.
                 // Using placeholder or nothing.
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

  void _onMadeIt(List<MealPlanWithRecipe> items) {
    if (items.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('お料理お疲れ様でした！'),
          content: const Text('もし作った料理を撮影した写真があったら、写真を貼っておくことで、後で見返すのが楽になります✨'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                 Navigator.pop(context);
                 _pickAndSaveImage(items, ImageSource.gallery);
              },
              child: const Text('撮った写真を貼る'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _pickAndSaveImage(items, ImageSource.camera);
              },
              child: const Text('撮影する'),
            ),
             TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('写真を貼らずに完了する'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickAndSaveImage(List<MealPlanWithRecipe> items, ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      if (items.isNotEmpty) {
        final target = items.first;
        try {
           final repo = await ref.read(mealPlanRepositoryProvider.future);
           final updatedPhotos = List<String>.from(target.mealPlan.photos)..add(image.path);
           final updatedPlan = target.mealPlan.copyWith(photos: updatedPhotos, isDone: true);
           await repo.save(updatedPlan);
           
           ref.invalidate(dailyMealPlanProvider);
        } catch (e) {
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('画像の保存に失敗しました: $e')));
          }
        }
      }
    }
  }

  void _onCook(List<MealPlanWithRecipe> items) {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('レシピがありません')));
      return;
    }
    
    final recipes = items.map((e) => e.recipe).whereType<Recipe>().toList();
    if (recipes.isNotEmpty) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => CookingModeScreen(recipes: recipes),
        ),
      );
    }
  }

  void _onAddDish(MealType type) {
    final date = ref.read(selectedDateProvider);
    SearchModal.show(
      context,
      initialDate: date,
      initialMealType: type,
    );
  }
}
