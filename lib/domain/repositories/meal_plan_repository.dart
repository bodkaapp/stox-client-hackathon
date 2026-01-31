import '../models/meal_plan.dart';

abstract class MealPlanRepository {
  Future<List<MealPlan>> getByDateRange(DateTime start, DateTime end);
  Future<List<MealPlan>> getEarlierThanDate(DateTime date, {int limit = 20});
  Future<void> save(MealPlan mealPlan);
  Future<void> delete(String id);
  Stream<List<MealPlan>> watchByDate(DateTime date);
}
