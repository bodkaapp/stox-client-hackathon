
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/recipe.dart';
import '../../domain/repositories/meal_plan_repository.dart';
import '../../infrastructure/repositories/drift_recipe_repository.dart';
import '../../infrastructure/repositories/drift_meal_plan_repository.dart';
import '../widgets/calendar/weekly_calendar_strip.dart';
import '../widgets/calendar/monthly_calendar_view.dart';

class RecipeScheduleScreen extends ConsumerStatefulWidget {
  final String title;
  final String url;
  final String? imageUrl;
  final String initialMemo;
  final DateTime? initialDate;
  final MealType? initialMealType;
  final String? existingRecipeId;

  const RecipeScheduleScreen({
    super.key,
    required this.title,
    required this.url,
    this.imageUrl,
    this.initialMemo = '',
    this.initialDate,
    this.initialMealType,
    this.existingRecipeId,
  });

  @override
  ConsumerState<RecipeScheduleScreen> createState() => _RecipeScheduleScreenState();
}

class _RecipeScheduleScreenState extends ConsumerState<RecipeScheduleScreen> {
  bool _isMonthlyView = false;
  DateTime? _selectedDate = DateTime.now(); // null means "Undecided"
  DateTime _focusedMonth = DateTime.now();
  String? _selectedTimeSlot; // 'morning', 'noon', 'night', 'snack', 'prep', 'appetizer'
  late final TextEditingController _memoController;

  final List<Map<String, String>> _timeSlots = [
    {'id': 'morning', 'label': '朝', 'icon': 'wb_twilight'},
    {'id': 'noon', 'label': '昼', 'icon': 'wb_sunny'},
    {'id': 'night', 'label': '夜', 'icon': 'dark_mode'},
    {'id': 'snack', 'label': 'おやつ', 'icon': 'cookie'},
    {'id': 'prep', 'label': '下ごしらえ', 'icon': 'skillet'},
    {'id': 'appetizer', 'label': 'おつまみ', 'icon': 'sports_bar'}, // material symbols mapping might differ
  ];

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: widget.initialMemo);
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      _focusedMonth = widget.initialDate!;
    }
    if (widget.initialMealType != null) {
      _selectedTimeSlot = _getSlotFromMealType(widget.initialMealType!);
    }
  }

  String? _getSlotFromMealType(MealType type) {
    switch (type) {
      case MealType.breakfast: return 'morning';
      case MealType.lunch: return 'noon';
      case MealType.dinner: return 'night';
      case MealType.snack: return 'snack';
      case MealType.preMade: return 'prep';
      case MealType.other: return 'appetizer';
      default: return null;
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'wb_twilight': return Icons.wb_twilight;
      case 'wb_sunny': return Icons.wb_sunny;
      case 'dark_mode': return Icons.dark_mode;
      case 'cookie': return Icons.cookie; // might not exist in standard icons
      case 'skillet': return Icons.soup_kitchen; // closest
      case 'sports_bar': return Icons.sports_bar;
      default: return Icons.access_time;
    }
  }

  // Workaround for missing icons in standard set if any
  Widget _buildIcon(String iconName, Color color) {
    IconData iconData;
    switch (iconName) {
      case 'wb_twilight': iconData = Icons.wb_twilight; break;
      case 'wb_sunny': iconData = Icons.wb_sunny; break;
      case 'dark_mode': iconData = Icons.dark_mode; break;
      case 'cookie': iconData = Icons.cake; break; // approximate
      case 'skillet': iconData = Icons.kitchen; break; // approximate
      case 'sports_bar': iconData = Icons.local_bar; break;
      default: iconData = Icons.restaurant;
    }
    return Icon(iconData, color: color, size: 24);
  }

  void _onConfirm() async {
    try {
      final recipeRepo = await ref.read(recipeRepositoryProvider.future);
      final mealPlanRepo = await ref.read(mealPlanRepositoryProvider.future);
      
      final recipeId = widget.existingRecipeId ?? DateTime.now().microsecondsSinceEpoch.toString();
      
      if (widget.existingRecipeId == null) {
        final recipe = Recipe(
          id: recipeId,
          title: widget.title,
          pageUrl: widget.url,
          ogpImageUrl: widget.imageUrl ?? '',
          createdAt: DateTime.now(),
          memo: _memoController.text, 
        );
        await recipeRepo.save(recipe);
      } else {
        // If recipe already exists (manual entry), should we update memo?
        // Let's update memo if changed, but keep ingredients if implementation_plan suggests.
        // For now, simpler: if existing, assume it's fresh and just use ID.
        // Or if we want to allow editing memo here:
        final existing = await recipeRepo.getById(recipeId);
        if (existing != null && _memoController.text != widget.initialMemo) {
           // Merging logic might be needed if we don't want to overwrite ingredients stored in memo (old plan)
           // But new plan uses separate table. So updating memo on Recipe entity is safe!
           await recipeRepo.save(existing.copyWith(memo: _memoController.text));
        }
      }

      if (_selectedDate != null && _selectedTimeSlot != null) {
          final mealType = _getMealType(_selectedTimeSlot!);
          final mealPlan = MealPlan(
            id: DateTime.now().microsecondsSinceEpoch.toString(), 
            recipeId: recipeId,
            date: _selectedDate!,
            mealType: mealType,
            isDone: false,
          );
          await mealPlanRepo.save(mealPlan);
      }
      
      if (mounted) {
        Navigator.pop(context); // Close Schedule Screen
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('マイレシピ帳に登録しました')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登録に失敗しました')),
        );
      }
    }
  }

  MealType _getMealType(String slot) {
    switch (slot) {
      case 'morning': return MealType.breakfast;
      case 'noon': return MealType.lunch;
      case 'night': return MealType.dinner;
      case 'snack': return MealType.snack;
      case 'prep': return MealType.preMade; // prep -> preMade (作り置き)
      case 'appetizer': return MealType.other; // appetizer -> other? Or handle specially. MealType enum: breakfast, lunch, dinner, snack, preMade, other. Let's map 'appetizer' to 'other' or maybe add 'appetizer' to enum later if needed. For now 'other'.
      default: return MealType.other;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      appBar: AppBar(
        backgroundColor: AppColors.stoxBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.stoxText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'いつ作りますか？',
          style: TextStyle(color: AppColors.stoxText, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month, color: _isMonthlyView ? AppColors.stoxPrimary : Colors.grey),
            onPressed: () {
              setState(() {
                _isMonthlyView = !_isMonthlyView;
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.stoxBorder, height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                    // Undecided Button (Only in Weekly View)
                    if (!_isMonthlyView) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _selectedDate == null ? AppColors.stoxBannerBg : Colors.white,
                              border: Border.all(
                                color: _selectedDate == null ? AppColors.stoxPrimary : AppColors.stoxBorder,
                                width: _selectedDate == null ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.help_outline, 
                                  color: _selectedDate == null ? AppColors.stoxPrimary : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '日程を未定にする',
                                  style: TextStyle(
                                    color: _selectedDate == null ? AppColors.stoxPrimary : Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'あとでカレンダーから設定できます',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    const SizedBox(height: 16),
                    
                    // Weekly Scroll or Monthly View
                    if (!_isMonthlyView) ...[
                      WeeklyCalendarStrip(
                        selectedDate: _selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                      ),
                    ] else ...[
                      MonthlyCalendarView(
                        selectedDate: _selectedDate,
                        focusedMonth: _focusedMonth,
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        onPageChanged: (date) {
                          setState(() {
                            _focusedMonth = date;
                          });
                        },
                      ),
                    ],

                  const SizedBox(height: 32),

                  // Time Slots
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('時間帯を選択', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.3,
                          physics: const NeverScrollableScrollPhysics(),
                          children: _timeSlots.map((slot) {
                            final isSelected = _selectedTimeSlot == slot['id'];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTimeSlot = slot['id'];
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.stoxBannerBg : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? AppColors.stoxPrimary : AppColors.stoxBorder,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildIcon(slot['icon']!, isSelected ? AppColors.stoxPrimary : AppColors.stoxPrimary),
                                    const SizedBox(height: 4),
                                    Text(
                                      slot['label']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: isSelected ? AppColors.stoxPrimary : AppColors.stoxText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Memo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('メモ（任意）', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextField(
                              controller: _memoController,
                              enabled: true, // Design says disabled? code.html says disabled="" but placeholder text implies editable. I'll make it editable.
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                hintText: 'その他（例：旦那さんの分、作り置き）',
                                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(Icons.edit_note, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              border: const Border(top: BorderSide(color: AppColors.stoxBorder)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.stoxPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      shadowColor: AppColors.stoxPrimary.withOpacity(0.5),
                      elevation: 4,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '確定する',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.check_circle, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24), // Approx home handle space
              ],
            ),
          ),
        ],
      ),
    );
  }


}
