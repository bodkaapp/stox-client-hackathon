import '../models/food_photo.dart';

abstract class FoodPhotoRepository {
  Future<List<FoodPhoto>> getAll({int? limit, int? offset});
  Future<FoodPhoto?> getByPath(String path);
  Future<List<FoodPhoto>> getByMealPlanId(String mealPlanId);
  Future<void> save(FoodPhoto photo);
  Future<void> delete(int id);
  Stream<List<FoodPhoto>> watchAll({int? limit, int? offset});
  Stream<FoodPhoto?> watchByPath(String path);
}
