import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/repositories/ingredient_repository.dart';
import '../datasources/app_database.dart';
import '../datasources/drift_database_provider.dart';

part 'drift_ingredient_repository.g.dart';

class DriftIngredientRepository implements IngredientRepository {
  final AppDatabase db;

  DriftIngredientRepository(this.db);

  @override
  Future<List<Ingredient>> getAll() async {
    final entities = await db.select(db.ingredients).get();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Ingredient?> getById(String id) async {
    final entity = await (db.select(db.ingredients)..where((t) => t.originalId.equals(id))).getSingleOrNull();
    return entity?.toDomain();
  }

  @override
  Future<void> save(Ingredient ingredient) async {
    final companion = IngredientDomainMapper.fromDomain(ingredient);
    
    final existing = await (db.select(db.ingredients)..where((t) => t.originalId.equals(ingredient.id))).getSingleOrNull();
    
    if (existing != null) {
      // Update
      await (db.update(db.ingredients)..where((t) => t.id.equals(existing.id))).write(companion);
    } else {
      // Insert
      await db.into(db.ingredients).insert(companion);
    }
  }
  
  @override
  Future<void> saveAll(List<Ingredient> ingredients) async {
    await db.transaction(() async {
      for (final ingredient in ingredients) {
        await save(ingredient);
      }
    });
  }

  @override
  Future<void> delete(String id) async {
     await (db.delete(db.ingredients)..where((t) => t.originalId.equals(id))).go();
  }

  @override
  Stream<List<Ingredient>> watchAll() {
    return db.select(db.ingredients).watch().map((entities) {
      return entities.map((e) => e.toDomain()).toList();
    });
  }
  
  @override
  Stream<List<Ingredient>> watchByStatus(IngredientStatus status) {
     return (db.select(db.ingredients)..where((t) => t.status.equals(status.index)))
        .watch()
        .map((entities) => entities.map((e) => e.toDomain()).toList());
  }
}

// Mappers
extension IngredientEntityMapper on IngredientEntity {
  Ingredient toDomain() {
    return Ingredient(
      id: originalId,
      name: name,
      standardName: standardName,
      category: category,
      unit: unit,
      status: IngredientStatus.values[status],
      storageType: StorageType.values[storageType],
      isEssential: isEssential,
      amount: amount,
      purchaseDate: purchaseDate,
      expiryDate: expiryDate,
      consumedAt: consumedAt,
    );
  }
}

extension IngredientDomainMapper on Ingredient {
  static IngredientsCompanion fromDomain(Ingredient ingredient) {
    return IngredientsCompanion(
      originalId: Value(ingredient.id),
      name: Value(ingredient.name),
      standardName: Value(ingredient.standardName),
      category: Value(ingredient.category),
      unit: Value(ingredient.unit),
      status: Value(ingredient.status.index),
      storageType: Value(ingredient.storageType.index),
      isEssential: Value(ingredient.isEssential),
      amount: Value(ingredient.amount),
      purchaseDate: Value(ingredient.purchaseDate),
      expiryDate: Value(ingredient.expiryDate),
      consumedAt: Value(ingredient.consumedAt),
    );
  }
}

@Riverpod(keepAlive: true)
Future<IngredientRepository> ingredientRepository(IngredientRepositoryRef ref) async {
  final db = ref.watch(driftDatabaseProvider);
  return DriftIngredientRepository(db);
}
