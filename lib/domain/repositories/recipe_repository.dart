import '../models/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getAll();
  Future<Recipe?> getById(String id);
  Future<Recipe?> findByUrl(String url);
  Future<void> save(Recipe recipe);
  Future<void> delete(String id);
  Future<List<Recipe>> search(String query);
  Stream<List<Recipe>> watchAll();
  Future<void> logView(String recipeId);
  Future<List<Recipe>> getRecent({int limit = 50, int offset = 0});
  Future<List<Recipe>> getRecentlyViewed({int limit = 50, int offset = 0});
}
