import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/repositories/ingredient_repository.dart';
import '../datasources/isar_database.dart';
import '../datasources/schemas/ingredient_schema.dart';

part 'isar_ingredient_repository.g.dart';

class IsarIngredientRepository implements IngredientRepository {
  final Isar isar;

  IsarIngredientRepository(this.isar);

  @override
  Future<List<Ingredient>> getAll() async {
    final collections = await isar.ingredientCollections.where().findAll();
    return collections.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Ingredient?> getById(String id) async {
    final collection = await isar.ingredientCollections.filter().originalIdEqualTo(id).findFirst();
    return collection?.toDomain();
  }

  @override
  Future<void> save(Ingredient ingredient) async {
    final collection = IngredientDomainMapper.fromDomain(ingredient);
    await isar.writeTxn(() async {
      // Need to find Id if updating
      final existing = await isar.ingredientCollections.filter().originalIdEqualTo(ingredient.id).findFirst();
      if (existing != null) {
        collection.id = existing.id;
      }
      await isar.ingredientCollections.put(collection);
    });
  }
  
  @override
  Future<void> saveAll(List<Ingredient> ingredients) async {
    await isar.writeTxn(() async {
      for (final ingredient in ingredients) {
        final collection = IngredientDomainMapper.fromDomain(ingredient);
        final existing = await isar.ingredientCollections.filter().originalIdEqualTo(ingredient.id).findFirst();
        if (existing != null) {
          collection.id = existing.id;
        }
        await isar.ingredientCollections.put(collection);
      }
    });
  }

  @override
  Future<void> delete(String id) async {
    await isar.writeTxn(() async {
      await isar.ingredientCollections.filter().originalIdEqualTo(id).deleteAll();
    });
  }

  @override
  Stream<List<Ingredient>> watchAll() {
    return isar.ingredientCollections.where().watch(fireImmediately: true).map((events) {
      return events.map((e) => e.toDomain()).toList();
    });
  }
  
  @override
  Stream<List<Ingredient>> watchByStatus(IngredientStatus status) {
     final statusSchema = IngredientStatusSchema.values[status.index];
     return isar.ingredientCollections
        .filter()
        .statusEqualTo(statusSchema)
        .watch(fireImmediately: true)
        .map((events) => events.map((e) => e.toDomain()).toList());
  }
}

// Mappers
extension IngredientMapper on IngredientCollection {
  Ingredient toDomain() {
    return Ingredient(
      id: originalId,
      name: name,
      standardName: standardName,
      category: category,
      unit: unit,
      status: IngredientStatus.values[status.index],
      storageType: StorageType.values[storageType.index],
      isEssential: isEssential,
      amount: amount,
      purchaseDate: purchaseDate,
      expiryDate: expiryDate,
      consumedAt: consumedAt,
    );
  }
}

extension IngredientDomainMapper on Ingredient {
  static IngredientCollection fromDomain(Ingredient ingredient) {
    return IngredientCollection()
      ..originalId = ingredient.id
      ..name = ingredient.name
      ..standardName = ingredient.standardName
      ..category = ingredient.category
      ..unit = ingredient.unit
      ..status = IngredientStatusSchema.values[ingredient.status.index]
      ..storageType = StorageTypeSchema.values[ingredient.storageType.index]
      ..isEssential = ingredient.isEssential
      ..amount = ingredient.amount
      ..purchaseDate = ingredient.purchaseDate
      ..expiryDate = ingredient.expiryDate
      ..consumedAt = ingredient.consumedAt;
  }
}

@Riverpod(keepAlive: true)
Future<IngredientRepository> ingredientRepository(IngredientRepositoryRef ref) async {
  final isar = await ref.watch(isarDatabaseProvider.future);
  return IsarIngredientRepository(isar);
}
