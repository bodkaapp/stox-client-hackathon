import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/repositories/meal_plan_repository.dart';
import '../datasources/app_database.dart';
import '../datasources/drift_database_provider.dart';

part 'drift_meal_plan_repository.g.dart';

class DriftMealPlanRepository implements MealPlanRepository {
  final AppDatabase db;

  DriftMealPlanRepository(this.db);

  @override
  Future<List<MealPlan>> getByDateRange(DateTime start, DateTime end) async {
    final entities = await (db.select(db.mealPlans)
      ..where((t) => t.date.isBetweenValues(start, end))
      ..orderBy([(t) => OrderingTerm(expression: t.date)])
    ).get();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<MealPlan>> getEarlierThanDate(DateTime date, {int limit = 20}) async {
    // Queries meal plans strictly before the given date
    // Ordered by date descending (newest first)
    final entities = await (db.select(db.mealPlans)
      ..where((t) => t.date.isSmallerThanValue(date))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
      ..limit(limit)
    ).get();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> save(MealPlan mealPlan) async {
    final companion = MealPlanDomainMapper.fromDomain(mealPlan);
    final existing = await (db.select(db.mealPlans)..where((t) => t.originalId.equals(mealPlan.id))).getSingleOrNull();
    
    if (existing != null) {
      await (db.update(db.mealPlans)..where((t) => t.id.equals(existing.id))).write(companion);
    } else {
      await db.into(db.mealPlans).insert(companion);
    }
  }

  @override
  Future<void> delete(String id) async {
     await (db.delete(db.mealPlans)..where((t) => t.originalId.equals(id))).go();
  }

  @override
  Stream<List<MealPlan>> watchByDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return (db.select(db.mealPlans)
        ..where((t) => t.date.isBetweenValues(start, end))
      ).watch().map((entities) => entities.map((e) => e.toDomain()).toList());
  }

  @override
  Stream<List<MealPlan>> watchEarlierThanDate(DateTime date, {int limit = 20}) {
    return (db.select(db.mealPlans)
      ..where((t) => t.date.isSmallerThanValue(date))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
      ..limit(limit)
    ).watch().map((entities) => entities.map((e) => e.toDomain()).toList());
  }
}

// Mappers
extension MealPlanEntityMapper on MealPlanEntity {
  MealPlan toDomain() {
    return MealPlan(
      id: originalId,
      recipeId: recipeId,
      date: date,
      mealType: MealType.values[mealType],
      isDone: isDone,
      photos: (json.decode(photos) as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
}

extension MealPlanDomainMapper on MealPlan {
  static MealPlansCompanion fromDomain(MealPlan mealPlan) {
    return MealPlansCompanion(
      originalId: Value(mealPlan.id),
      recipeId: Value(mealPlan.recipeId),
      date: Value(mealPlan.date),
      mealType: Value(mealPlan.mealType.index),
      isDone: Value(mealPlan.isDone),
      photos: Value(json.encode(mealPlan.photos)),
    );
  }
}

@Riverpod(keepAlive: true)
Future<MealPlanRepository> mealPlanRepository(MealPlanRepositoryRef ref) async {
  final db = ref.watch(driftDatabaseProvider);
  return DriftMealPlanRepository(db);
}
