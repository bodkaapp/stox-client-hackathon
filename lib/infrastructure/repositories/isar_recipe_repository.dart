import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/isar_database.dart';
import '../datasources/schemas/recipe_schema.dart';

part 'isar_recipe_repository.g.dart';

class IsarRecipeRepository implements RecipeRepository {
  final Isar isar;

  IsarRecipeRepository(this.isar);

  @override
  Future<List<Recipe>> getAll() async {
    final collections = await isar.recipeCollections.where().findAll();
    return collections.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Recipe?> getById(String id) async {
    final collection = await isar.recipeCollections.filter().originalIdEqualTo(id).findFirst();
    return collection?.toDomain();
  }

  @override
  Future<void> save(Recipe recipe) async {
    final collection = RecipeDomainMapper.fromDomain(recipe);
    await isar.writeTxn(() async {
      await isar.recipeCollections.put(collection);
    });
  }

  @override
  Future<void> delete(String id) async {
    await isar.writeTxn(() async {
      await isar.recipeCollections.filter().originalIdEqualTo(id).deleteAll();
    });
  }

  @override
  Future<List<Recipe>> search(String query) async {
    // Basic search on title
    final collections = await isar.recipeCollections
        .filter()
        .titleContains(query, caseSensitive: false)
        .findAll();
    return collections.map((e) => e.toDomain()).toList();
  }

  @override
  Stream<List<Recipe>> watchAll() {
    return isar.recipeCollections.where().watch(fireImmediately: true).map((events) {
      return events.map((e) => e.toDomain()).toList();
    });
  }
}

// Mappers
extension RecipeMapper on RecipeCollection {
  Recipe toDomain() {
    return Recipe(
      id: originalId,
      title: title,
      pageUrl: pageUrl,
      ogpImageUrl: ogpImageUrl,
      createdAt: createdAt,
      cookedCount: cookedCount,
      defaultServings: defaultServings,
      rating: rating,
      lastCookedAt: lastCookedAt,
      isDeleted: isDeleted,
      memo: memo,
    );
  }
}

extension RecipeDomainMapper on Recipe {
  static RecipeCollection fromDomain(Recipe recipe) {
    return RecipeCollection()
      ..originalId = recipe.id
      ..title = recipe.title
      ..pageUrl = recipe.pageUrl
      ..ogpImageUrl = recipe.ogpImageUrl
      ..createdAt = recipe.createdAt
      ..cookedCount = recipe.cookedCount
      ..defaultServings = recipe.defaultServings
      ..rating = recipe.rating
      ..lastCookedAt = recipe.lastCookedAt
      ..isDeleted = recipe.isDeleted
      ..memo = recipe.memo;
  }
}

@Riverpod(keepAlive: true)
Future<RecipeRepository> recipeRepository(RecipeRepositoryRef ref) async {
  final isar = await ref.watch(isarDatabaseProvider.future);
  return IsarRecipeRepository(isar);
}
