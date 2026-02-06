import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../infrastructure/repositories/drift_photo_analysis_repository.dart';
import '../../domain/models/meal_plan.dart';
import '../../infrastructure/repositories/drift_meal_plan_repository.dart';

part 'nutrition_viewmodel.g.dart';

class NutritionalSummary {
  final int calories;
  final double protein;
  final double fat;
  final double carbs;

   NutritionalSummary({
    this.calories = 0,
    this.protein = 0,
    this.fat = 0,
    this.carbs = 0,
  });

  NutritionalSummary operator +(NutritionalSummary other) {
    return NutritionalSummary(
      calories: calories + other.calories,
      protein: protein + other.protein,
      fat: fat + other.fat,
      carbs: carbs + other.carbs,
    );
  }
}

@riverpod
Future<NutritionalSummary> mealNutritionalSummary(MealNutritionalSummaryRef ref, List<String> photoPaths) async {
  if (photoPaths.isEmpty) return NutritionalSummary();

  final repository = await ref.watch(photoAnalysisRepositoryProvider.future);
  
  int totalCalories = 0;
  double totalProtein = 0;
  double totalFat = 0;
  double totalCarbs = 0;

  for (final path in photoPaths) {
    final analysis = await repository.getByPath(path);
    if (analysis != null) {
      totalCalories += analysis.calories ?? 0;
      totalProtein += analysis.protein ?? 0;
      totalFat += analysis.fat ?? 0;
      totalCarbs += analysis.carbs ?? 0;
    }
  }

  return NutritionalSummary(
    calories: totalCalories,
    protein: totalProtein,
    fat: totalFat,
    carbs: totalCarbs,
  );
}

@riverpod
Future<NutritionalSummary> dailyNutritionalSummary(DailyNutritionalSummaryRef ref, List<MealPlan> mealPlans) async {
  NutritionalSummary total = NutritionalSummary();

  for (final plan in mealPlans) {
    if (plan.photos.isNotEmpty) {
      final summary = await ref.watch(mealNutritionalSummaryProvider(plan.photos).future);
      total = total + summary;
    }
  }

  return total;
}

@riverpod
Future<Map<MealType, NutritionalSummary>> dailyDetailedNutritionalSummary(DailyDetailedNutritionalSummaryRef ref, List<MealPlan> mealPlans) async {
  final Map<MealType, NutritionalSummary> detailedSummary = {
    for (var type in MealType.values) type: NutritionalSummary()
  };

  for (final plan in mealPlans) {
    if (plan.photos.isNotEmpty) {
      final summary = await ref.watch(mealNutritionalSummaryProvider(plan.photos).future);
      detailedSummary[plan.mealType] = (detailedSummary[plan.mealType] ?? NutritionalSummary()) + summary;
    }
  }

  return detailedSummary;
}

@riverpod
Future<NutritionalSummary> averageNutritionalSummary(AverageNutritionalSummaryRef ref, {required int days}) async {
  final mealRepo = await ref.watch(mealPlanRepositoryProvider.future);
  final now = DateTime.now();
  final startDate = now.subtract(Duration(days: days));
  
  final plans = await mealRepo.getByDateRange(startDate, now);
  if (plans.isEmpty) return NutritionalSummary();

  NutritionalSummary total = NutritionalSummary();
  int countedDays = 0;
  Set<String> processedDays = {};

  for (final plan in plans) {
    if (plan.photos.isNotEmpty) {
      final summary = await ref.watch(mealNutritionalSummaryProvider(plan.photos).future);
      total = total + summary;
      processedDays.add("${plan.date.year}-${plan.date.month}-${plan.date.day}");
    }
  }
  
  countedDays = processedDays.length;
  if (countedDays == 0) return NutritionalSummary();

  return NutritionalSummary(
    calories: total.calories ~/ countedDays,
    protein: total.protein / countedDays,
    fat: total.fat / countedDays,
    carbs: total.carbs / countedDays,
  );
}
