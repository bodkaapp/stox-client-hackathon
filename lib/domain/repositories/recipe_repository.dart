import '../models/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getAll();
  Future<Recipe?> getById(String id);
  Future<void> save(Recipe recipe);
  Future<void> delete(String id);
  Future<List<Recipe>> search(String query);
  Stream<List<Recipe>> watchAll();
}
