import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_plan.freezed.dart';
part 'meal_plan.g.dart';

enum MealType {
  breakfast,
  lunch,
  dinner,
  snack,
  preMade, // 作り置き
  other,
}

@freezed
class MealPlan with _$MealPlan {
  const factory MealPlan({
    required String id,
    required String recipeId,
    required DateTime date,
    required MealType mealType,
    @Default(false) bool isDone,
    @Default([]) List<String> photos,
  }) = _MealPlan;

  factory MealPlan.fromJson(Map<String, dynamic> json) => _$MealPlanFromJson(json);
}
