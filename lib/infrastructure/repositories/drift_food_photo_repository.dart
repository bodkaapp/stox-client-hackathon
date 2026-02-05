import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/food_photo.dart';
import '../../domain/repositories/food_photo_repository.dart';
import '../datasources/app_database.dart';
import '../datasources/drift_database_provider.dart';

part 'drift_food_photo_repository.g.dart';

class DriftFoodPhotoRepository implements FoodPhotoRepository {
  final AppDatabase db;

  DriftFoodPhotoRepository(this.db);

  @override
  Future<List<FoodPhoto>> getAll({int? limit, int? offset}) async {
    final query = db.select(db.foodPhotos)
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
    
    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    final entities = await query.get();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<FoodPhoto?> getByPath(String path) async {
    final entity = await (db.select(db.foodPhotos)..where((t) => t.path.equals(path))).getSingleOrNull();
    return entity?.toDomain();
  }

  @override
  Future<List<FoodPhoto>> getByMealPlanId(String mealPlanId) async {
    final entities = await (db.select(db.foodPhotos)
      ..where((t) => t.mealPlanId.equals(mealPlanId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
    ).get();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> save(FoodPhoto photo) async {
    final companion = FoodPhotoDomainMapper.fromDomain(photo);
    await db.into(db.foodPhotos).insert(companion, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> delete(int id) async {
    await (db.delete(db.foodPhotos)..where((t) => t.id.equals(id))).go();
  }

  @override
  Stream<List<FoodPhoto>> watchAll({int? limit, int? offset}) {
    final query = db.select(db.foodPhotos)
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
    
    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    return query.watch().map((entities) => entities.map((e) => e.toDomain()).toList());
  }

  @override
  Stream<FoodPhoto?> watchByPath(String path) {
    return (db.select(db.foodPhotos)..where((t) => t.path.equals(path)))
        .watchSingleOrNull()
        .map((entity) => entity?.toDomain());
  }
}

// Mappers
extension FoodPhotoEntityMapper on FoodPhotoEntity {
  FoodPhoto toDomain() {
    return FoodPhoto(
      id: id,
      path: path,
      createdAt: createdAt,
      mealPlanId: mealPlanId,
    );
  }
}

extension FoodPhotoDomainMapper on FoodPhoto {
  static FoodPhotosCompanion fromDomain(FoodPhoto photo) {
    return FoodPhotosCompanion(
      id: photo.id > 0 ? Value(photo.id) : const Value.absent(),
      path: Value(photo.path),
      createdAt: Value(photo.createdAt),
      mealPlanId: Value(photo.mealPlanId),
    );
  }
}

@Riverpod(keepAlive: true)
Future<FoodPhotoRepository> foodPhotoRepository(FoodPhotoRepositoryRef ref) async {
  final db = ref.watch(driftDatabaseProvider);
  return DriftFoodPhotoRepository(db);
}
