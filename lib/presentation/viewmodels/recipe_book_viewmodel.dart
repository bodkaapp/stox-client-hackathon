import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/recipe.dart';
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
