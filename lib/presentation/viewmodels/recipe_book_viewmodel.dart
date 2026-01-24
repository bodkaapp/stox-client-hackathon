import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/recipe.dart';
import '../../domain/repositories/meal_plan_repository.dart';
import '../../infrastructure/repositories/isar_meal_plan_repository.dart';
import '../../infrastructure/repositories/isar_recipe_repository.dart';

part 'recipe_book_viewmodel.g.dart';

@riverpod
class RecipeBookViewModel extends _$RecipeBookViewModel {
  @override
  Future<List<Recipe>> build() async {
    final repo = await ref.watch(recipeRepositoryProvider.future);
    return repo.getAll();
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
     ref.invalidateSelf();
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
