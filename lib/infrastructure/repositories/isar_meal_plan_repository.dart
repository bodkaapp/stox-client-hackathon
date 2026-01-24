import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/repositories/meal_plan_repository.dart';
import '../datasources/isar_database.dart';
import '../datasources/schemas/meal_plan_schema.dart';

part 'isar_meal_plan_repository.g.dart';

class IsarMealPlanRepository implements MealPlanRepository {
  final Isar isar;

  IsarMealPlanRepository(this.isar);

  @override
  Future<List<MealPlan>> getByDateRange(DateTime start, DateTime end) async {
    final collections = await isar.mealPlanCollections
        .filter()
        .dateBetween(start, end)
        .sortByDate()
        .findAll();
    return collections.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> save(MealPlan mealPlan) async {
    final collection = MealPlanDomainMapper.fromDomain(mealPlan);
    await isar.writeTxn(() async {
      final existing = await isar.mealPlanCollections.filter().originalIdEqualTo(mealPlan.id).findFirst();
      if (existing != null) {
        collection.id = existing.id;
      }
      await isar.mealPlanCollections.put(collection);
    });
  }

  @override
  Future<void> delete(String id) async {
    await isar.writeTxn(() async {
      await isar.mealPlanCollections.filter().originalIdEqualTo(id).deleteAll();
    });
  }

  @override
  Stream<List<MealPlan>> watchByDate(DateTime date) {
    // Filter by day (start of day to end of day)
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return isar.mealPlanCollections
        .filter()
        .dateBetween(start, end)
        .watch(fireImmediately: true)
        .map((events) => events.map((e) => e.toDomain()).toList());
  }
}

// Mappers
extension MealPlanMapper on MealPlanCollection {
  MealPlan toDomain() {
    return MealPlan(
      id: originalId,
      recipeId: recipeId,
      date: date,
      mealType: MealType.values[mealType.index],
      isDone: isDone,
    );
  }
}

extension MealPlanDomainMapper on MealPlan {
  static MealPlanCollection fromDomain(MealPlan mealPlan) {
    return MealPlanCollection()
      ..originalId = mealPlan.id
      ..recipeId = mealPlan.recipeId
      ..date = mealPlan.date
      ..mealType = MealTypeSchema.values[mealPlan.mealType.index]
      ..isDone = mealPlan.isDone;
  }
}

@Riverpod(keepAlive: true)
Future<MealPlanRepository> mealPlanRepository(MealPlanRepositoryRef ref) async {
  final isar = await ref.watch(isarDatabaseProvider.future);
  return IsarMealPlanRepository(isar);
}
