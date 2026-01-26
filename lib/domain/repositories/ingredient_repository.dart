import '../models/ingredient.dart';

abstract class IngredientRepository {
  Future<List<Ingredient>> getAll();
  Future<Ingredient?> getById(String id);
  Future<void> save(Ingredient ingredient);
  Future<void> saveAll(List<Ingredient> ingredients);
  Future<void> delete(String id);
  Stream<List<Ingredient>> watchAll();
  Stream<List<Ingredient>> watchByStatus(IngredientStatus status);
  Future<void> incrementInfoUsageCount(String name);
  Future<List<String>> getTopSuggestions({int limit = 20});
}
