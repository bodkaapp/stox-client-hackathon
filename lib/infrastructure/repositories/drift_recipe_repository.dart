import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/app_database.dart';
import '../datasources/drift_database_provider.dart';

part 'drift_recipe_repository.g.dart';

class DriftRecipeRepository implements RecipeRepository {
  final AppDatabase db;

  DriftRecipeRepository(this.db);

  @override
  Future<List<Recipe>> getAll() async {
    final entities = await db.select(db.recipes).get();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Recipe?> getById(String id) async {
    final entity = await (db.select(db.recipes)..where((t) => t.originalId.equals(id))).getSingleOrNull();
    return entity?.toDomain();
  }

  @override
  Future<void> save(Recipe recipe) async {
    final companion = RecipeDomainMapper.fromDomain(recipe);
    
    final existing = await (db.select(db.recipes)..where((t) => t.originalId.equals(recipe.id))).getSingleOrNull();
    
    if (existing != null) {
      // Update using companion on the existing row
      // We can use update statement
      await (db.update(db.recipes)..where((t) => t.id.equals(existing.id))).write(companion);
    } else {
      // Insert
      await db.into(db.recipes).insert(companion);
    }
  }

  @override
  Future<void> delete(String id) async {
    await (db.delete(db.recipes)..where((t) => t.originalId.equals(id))).go();
  }

  @override
  Future<List<Recipe>> search(String query) async {
    final entities = await (db.select(db.recipes)..where((t) => t.title.contains(query) | t.memo.contains(query))).get();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Stream<List<Recipe>> watchAll() {
    return db.select(db.recipes).watch().map((entities) {
      return entities.map((e) => e.toDomain()).toList();
    });
  }
}

// Mappers
extension RecipeEntityMapper on RecipeEntity {
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
      isDeleted: Value(recipe.isDeleted),
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
