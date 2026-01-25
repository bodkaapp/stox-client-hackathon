import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'schemas/recipe_schema.dart';
import 'schemas/ingredient_schema.dart';
import 'schemas/meal_plan_schema.dart';
import 'schemas/user_schema.dart';
import 'schemas/search_history_schema.dart';

part 'isar_database.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarDatabase(IsarDatabaseRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [
      RecipeCollectionSchema,
      IngredientCollectionSchema,
      MealPlanCollectionSchema,
      UserCollectionSchema,
      SearchHistoryCollectionSchema,
    ],
    directory: dir.path,
  );
}
