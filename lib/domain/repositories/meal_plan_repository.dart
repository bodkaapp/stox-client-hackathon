import '../models/meal_plan.dart';

abstract class MealPlanRepository {
  Future<List<MealPlan>> getByDateRange(DateTime start, DateTime end);
  Future<List<MealPlan>> getEarlierThanDate(DateTime date, {int limit = 20});
  Future<void> save(MealPlan mealPlan);
  Future<void> delete(String id);
  Stream<List<MealPlan>> watchByDate(DateTime date);
  Stream<List<MealPlan>> watchEarlierThanDate(DateTime date, {int limit = 20});
  Future<List<MealPlan>> getWithPhotos({int limit = 50, int offset = 0});
}
