import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/repositories/meal_plan_repository.dart';
import '../../infrastructure/repositories/drift_meal_plan_repository.dart';
import '../../infrastructure/repositories/drift_recipe_repository.dart';

part 'recipe_book_viewmodel.g.dart';

@riverpod
class RecipeBookViewModel extends _$RecipeBookViewModel {
  @override
  Stream<List<Recipe>> build() {
    final repo = ref.watch(recipeRepositoryProvider).valueOrNull;
    if (repo == null) {
      // Return empty stream or handle loading if repo is strictly async initially
      // Since repo provider is Future, we might yield empty or effectively wait.
      // However, usually repositories are initialized quickly.
      // Better approach: wrap in stream.
      return Stream.value([]);
    }
    return repo.watchAll();
  }
  
  Future<void> addSampleRecipe() async {
     final repo = await ref.watch(recipeRepositoryProvider.future);
     await repo.save(Recipe(
       id: DateTime.now().toIso8601String(),
       title: 'Delicious Curry',
       pageUrl: 'https://example.com/curry',
       ogpImageUrl: 'https://example.com/image.png',
       createdAt: DateTime.now(),
     ));
     // ref.invalidateSelf(); // No longer needed with Stream
  }
}

@riverpod
Stream<List<Recipe>> todaysMenu(TodaysMenuRef ref) async* {
  final mealPlanRepo = await ref.watch(mealPlanRepositoryProvider.future);
  final recipeRepo = await ref.watch(recipeRepositoryProvider.future);
  
  yield* mealPlanRepo.watchByDate(DateTime.now()).asyncMap((plans) async {
    // 1. Filter not done
    final notDonePlans = plans.where((p) => !p.isDone).toList();
    if (notDonePlans.isEmpty) return [];

    // 2. Sort by mealType priority
    // breakfast < lunch < dinner < snack < preMade < other
    notDonePlans.sort((a, b) => a.mealType.index.compareTo(b.mealType.index));

    // 3. Get the first priority type
    final priorityType = notDonePlans.first.mealType;

    // 4. Filter by that type
    final targetPlans = notDonePlans.where((p) => p.mealType == priorityType).toList();

    // 5. Get recipes
    final recipes = <Recipe>[];
    for (final plan in targetPlans) {
      final recipe = await recipeRepo.getById(plan.recipeId);
      if (recipe != null) {
        recipes.add(recipe);
      }
    }

    return recipes;
  });
}

@riverpod
Stream<List<DailyMenu>> pastMenus(PastMenusRef ref) async* {
  final mealPlanRepo = await ref.watch(mealPlanRepositoryProvider.future);
  final recipeRepo = await ref.watch(recipeRepositoryProvider.future);

  // Watch past 20 meal plans
  yield* mealPlanRepo.watchEarlierThanDate(DateTime.now()).asyncMap((plans) async {
    // Group by date
    final grouped = <DateTime, List<MealPlan>>{};
    for (final plan in plans) {
      // Normalize date to YMD
      final date = DateTime(plan.date.year, plan.date.month, plan.date.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(plan);
    }

    final results = <DailyMenu>[];
    for (final entry in grouped.entries) {
      final date = entry.key;
      final dayPlans = entry.value;

      final recipes = <Recipe>[];
      for (final plan in dayPlans) {
        final recipe = await recipeRepo.getById(plan.recipeId);
        if (recipe != null) {
          recipes.add(recipe);
        }
      }

      if (recipes.isNotEmpty) {
        results.add(DailyMenu(date: date, recipes: recipes));
      }
    }
    return results;
  });
}

class DailyMenu {
  final DateTime date;
  final List<Recipe> recipes;

  DailyMenu({required this.date, required this.recipes});
}
