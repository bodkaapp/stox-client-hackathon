import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/app_database.dart';
import '../../domain/models/recipe_ingredient.dart';
import '../datasources/drift_database_provider.dart';

part 'drift_recipe_repository.g.dart';

class DriftRecipeRepository implements RecipeRepository {
  final AppDatabase db;

  DriftRecipeRepository(this.db);

  @override
  Future<List<Recipe>> getAll() async {
    // Filter out temporary recipes
    final entities = await (db.select(db.recipes)..where((t) => t.isTemporary.equals(false))).get();
    
    // Performance note: N+1 query. For many recipes, should fetch all ingredients and map in memory.
    // For now, simple loop or batch fetch.
    // Since expected number of saved recipes isn't huge yet, let's keep it simple or do 2 queries.
    // 2 queries approach:
    final recipeIds = entities.map((e) => e.originalId).toList();
    final allIngredients = await (db.select(db.recipeIngredients)..where((t) => t.recipeId.isIn(recipeIds))).get();
    
    final ingredientMap = <String, List<RecipeIngredientEntity>>{};
    for (var ing in allIngredients) {
      if (!ingredientMap.containsKey(ing.recipeId)) {
        ingredientMap[ing.recipeId] = [];
      }
      ingredientMap[ing.recipeId]!.add(ing);
    }

    return entities.map((e) {
      final ingredients = ingredientMap[e.originalId] ?? [];
      ingredients.sort((a, b) => a.index.compareTo(b.index));
      return e.toDomain(ingredients: ingredients);
    }).toList();
  }

  @override
  Future<Recipe?> getById(String id) async {
    final entity = await (db.select(db.recipes)..where((t) => t.originalId.equals(id))).getSingleOrNull();
    if (entity == null) return null;

    final ingredients = await (db.select(db.recipeIngredients)
      ..where((t) => t.recipeId.equals(id))
      ..orderBy([(t) => OrderingTerm(expression: t.index, mode: OrderingMode.asc)]))
      .get();
      
    return entity.toDomain(ingredients: ingredients);
  }

  @override
  Future<Recipe?> findByUrl(String url) async {
    // Check both pageUrl and originalId (if needed, but mainly pageUrl)
    // We want to find ANY recipe (temporary or not) to avoid duplicates
    final entity = await (db.select(db.recipes)..where((t) => t.pageUrl.equals(url))).getSingleOrNull();
    if (entity == null) return null;

    // We don't necessarily need ingredients for just checking existence/logging
    // But to match signature, let's fetch them or return empty if lazy
    return entity.toDomain(); 
  }

  @override
  Future<String> save(Recipe recipe) async {
    final companion = RecipeDomainMapper.fromDomain(recipe);
    
    return await db.transaction(() async {
      // Check for existence by originalId OR pageUrl to merge temporary
      RecipeEntity? existing;
      
      existing = await (db.select(db.recipes)..where((t) => t.originalId.equals(recipe.id))).getSingleOrNull();
      
      if (existing == null) {
         // Fallback: check by URL if we are trying to save a recipe that might exist as temporary
         existing = await (db.select(db.recipes)..where((t) => t.pageUrl.equals(recipe.pageUrl))).getSingleOrNull();
      }

      final targetId = existing?.originalId ?? recipe.id;

      if (existing != null) {
        // Update existing record
        final toWrite = companion.copyWith(
           originalId: Value(existing.originalId) // Ensure we keep the DB id
        );

        await (db.update(db.recipes)..where((t) => t.originalId.equals(existing!.originalId))).write(toWrite);
        
        // Delete existing ingredients
        await (db.delete(db.recipeIngredients)..where((t) => t.recipeId.equals(existing!.originalId))).go();
      } else {
        await db.into(db.recipes).insert(companion);
      }

      // Insert new ingredients
      if (recipe.ingredients.isNotEmpty) {
        final ingredients = recipe.ingredients.asMap().entries.map((e) {
          return RecipeIngredientsCompanion(
            recipeId: Value(targetId),
            name: Value(e.value.name),
            amount: Value(e.value.amount),
            index: Value(e.key),
          );
        }).toList();
        
        await db.batch((batch) {
          batch.insertAll(db.recipeIngredients, ingredients);
        });
      }

      return targetId;
    });
  }

  @override
  Future<void> delete(String id) async {
    await (db.delete(db.recipes)..where((t) => t.originalId.equals(id))).go();
  }

  @override
  Future<List<Recipe>> search(String query) async {
    // Search scans all? Or only saved? Probably both or saved. Let's say Saved for now to treat temp as hidden.
    final entities = await (db.select(db.recipes)
      ..where((t) => (t.title.contains(query) | t.memo.contains(query)) & t.isTemporary.equals(false))
    ).get();
    
    if (entities.isEmpty) return [];

    final recipeIds = entities.map((e) => e.originalId).toList();
    final allIngredients = await (db.select(db.recipeIngredients)..where((t) => t.recipeId.isIn(recipeIds))).get();
    
    final ingredientMap = <String, List<RecipeIngredientEntity>>{};
    for (var ing in allIngredients) {
      if (!ingredientMap.containsKey(ing.recipeId)) {
        ingredientMap[ing.recipeId] = [];
      }
      ingredientMap[ing.recipeId]!.add(ing);
    }

    return entities.map((e) {
      final ingredients = ingredientMap[e.originalId] ?? [];
      ingredients.sort((a, b) => a.index.compareTo(b.index));
      return e.toDomain(ingredients: ingredients);
    }).toList();
  }

  @override
  Future<void> logView(String recipeId) async {
    await (db.update(db.recipes)..where((t) => t.originalId.equals(recipeId))).write(
      RecipesCompanion(lastViewedAt: Value(DateTime.now())),
    );
  }

  @override
  Future<List<Recipe>> getRecent({int limit = 50, int offset = 0}) async {
    // Only saved recipes
    final entities = await (db.select(db.recipes)
      ..where((t) => t.isTemporary.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
      ..limit(limit, offset: offset)
    ).get();

    return _mapEntitiesToRecipes(entities);
  }

  @override
  Future<List<Recipe>> getRecentlyViewed({int limit = 50, int offset = 0}) async {
    // Viewed - include temporary! (User wants history of everything viewed)
    final entities = await (db.select(db.recipes)
      ..where((t) => t.lastViewedAt.isNotNull())
      ..orderBy([(t) => OrderingTerm(expression: t.lastViewedAt, mode: OrderingMode.desc)])
      ..limit(limit, offset: offset)
    ).get();

    return _mapEntitiesToRecipes(entities);
  }

  Future<List<Recipe>> _mapEntitiesToRecipes(List<RecipeEntity> entities) async {
    if (entities.isEmpty) return [];

    final recipeIds = entities.map((e) => e.originalId).toList();
    final allIngredients = await (db.select(db.recipeIngredients)..where((t) => t.recipeId.isIn(recipeIds))).get();
    
    final ingredientMap = <String, List<RecipeIngredientEntity>>{};
    for (var ing in allIngredients) {
      if (!ingredientMap.containsKey(ing.recipeId)) {
        ingredientMap[ing.recipeId] = [];
      }
      ingredientMap[ing.recipeId]!.add(ing);
    }

    return entities.map((e) {
      final ingredients = ingredientMap[e.originalId] ?? [];
      ingredients.sort((a, b) => a.index.compareTo(b.index));
      return e.toDomain(ingredients: ingredients);
    }).toList();
  }

  @override
  Stream<List<Recipe>> watchAll() {
    return (db.select(db.recipes)..where((t) => t.isTemporary.equals(false)))
      .watch()
      .map((entities) {
        return entities.map((e) => e.toDomain()).toList();
      });
  }
}

// Mappers
extension RecipeEntityMapper on RecipeEntity {
  Recipe toDomain({List<RecipeIngredientEntity> ingredients = const []}) {
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
      lastViewedAt: lastViewedAt,
      isDeleted: isDeleted,
      isTemporary: isTemporary,
      memo: memo,
      ingredients: ingredients.map((e) => RecipeIngredient(name: e.name, amount: e.amount)).toList(),
    );
  }
}

extension RecipeDomainMapper on Recipe {
  static RecipesCompanion fromDomain(Recipe recipe) {
    return RecipesCompanion(
      originalId: Value(recipe.id),
      title: Value(recipe.title),
      pageUrl: Value(recipe.pageUrl),
      ogpImageUrl: Value(recipe.ogpImageUrl),
      createdAt: Value(recipe.createdAt),
      cookedCount: Value(recipe.cookedCount),
      defaultServings: Value(recipe.defaultServings),
      rating: Value(recipe.rating),
      lastCookedAt: Value(recipe.lastCookedAt),
      lastViewedAt: Value(recipe.lastViewedAt),
      isDeleted: Value(recipe.isDeleted),
      isTemporary: Value(recipe.isTemporary),
      memo: Value(recipe.memo),
    );
  }
  // Note: For full entity creation (not companion), we need to handle id. 
  // But usage above uses Companion or Data depending on API.
  // Drift's insert accepts Companion. update.replace accepts Data.
  // Let's refine implementation to work seamlessly.
}

extension RecipeEntityDataHelper on RecipesCompanion {
  // Helper if needed to convert compatible types
  RecipeEntity copyWith({int? id}) {
     // This logic is tricky if mixing Companion and matching Data.
     // Better to use Companion for Insert/Update?
     // For replace, we need Data class which has ID.
     // Or we can use update statement with companion.
     return RecipeEntity(
       id: id ?? 0, // Placeholder
       originalId: originalId.value,
       title: title.value,
       pageUrl: pageUrl.value,
       ogpImageUrl: ogpImageUrl.value,
       createdAt: createdAt.value,
       cookedCount: cookedCount.value,
       defaultServings: defaultServings.value,
       rating: rating.value,
       lastCookedAt: lastCookedAt.value,
       isDeleted: isDeleted.value,
       isTemporary: isTemporary.value,
       memo: memo.value,
     );
  }
}
// Actually, standard pattern:
// Insert uses Companion.
// Update uses copyWith on existing Data or update statement with Companion.
// I used `db.update(db.recipes).replace(updated)`. `replace` expects `RecipeEntity` (Data).
// `RecipeDomainMapper` below returns Companion.
// I should adjust save method or mapper.
// Let's change mapper to return Companion, and logic handles conversion.

@Riverpod(keepAlive: true)
Future<RecipeRepository> recipeRepository(RecipeRepositoryRef ref) async {
  final db = ref.watch(driftDatabaseProvider);
  return DriftRecipeRepository(db);
}
