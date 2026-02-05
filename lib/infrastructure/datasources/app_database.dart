import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
// import 'package:drift_flutter/drift_flutter.dart'; // No longer needed for helper
import 'package:path_provider/path_provider.dart';
import 'drift_schemas.dart';
import 'package:flutter/foundation.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Recipes, Ingredients, MealPlans, SearchHistories, UserSettings, IngredientAddHistories, Notifications, RecipeIngredients, PhotoAnalyses, FoodPhotos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        debugPrint('=== DB onCreate: Creating new database tables ===');
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        debugPrint('=== DB onUpgrade: Upgrading from $from to $to ===');
        if (from < 2) {
          await m.createTable(ingredientAddHistories);
        }
        if (from < 3) {
          await m.createTable(notifications);
        }
        if (from < 4) {
          await m.addColumn(mealPlans, mealPlans.photos);
        }
        if (from < 5) {
          await m.createTable(recipeIngredients);
        }
        if (from < 6) {
          await m.addColumn(mealPlans, mealPlans.completedAt);
        }
        if (from < 7) {
          await m.createTable(photoAnalyses);
        }
        if (from < 8) {
          await m.addColumn(recipes, recipes.lastViewedAt);
        }
        if (from < 9) {
          await m.addColumn(recipes, recipes.isTemporary);
        }
        if (from < 10) {
          await m.createTable(foodPhotos);
          
          // Migrate existing photos from MealPlans to FoodPhotos
          final allPlans = await select(mealPlans).get();
          for (final plan in allPlans) {
            try {
              final photoPaths = (json.decode(plan.photos) as List<dynamic>).map((e) => e.toString()).toList();
              for (final path in photoPaths) {
                await into(foodPhotos).insert(FoodPhotosCompanion.insert(
                  path: path,
                  createdAt: plan.completedAt ?? plan.date,
                  mealPlanId: Value(plan.originalId),
                ), mode: InsertMode.insertOrReplace);
              }
            } catch (e) {
              debugPrint('Error migrating photos for plan ${plan.originalId}: $e');
            }
          }
        }
      },
      beforeOpen: (details) async {
        debugPrint('=== DB beforeOpen: Version ${details.versionBefore} -> ${details.versionNow} ===');
        if (details.wasCreated) {
          debugPrint('=== DB wasCreated: TRUE ===');
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      // Use SupportDirectory for better persistence on Android
      final dbFolder = await getApplicationSupportDirectory();
      final file = File(p.join(dbFolder.path, 'stox_db.sqlite'));
      return NativeDatabase(file);
    });
  }
}
