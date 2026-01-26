import 'package:drift/drift.dart';

// Drift Tables

@DataClassName('RecipeEntity')
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get originalId => text()(); // ID from backend or generated UUID
  TextColumn get title => text()();
  TextColumn get pageUrl => text()();
  TextColumn get ogpImageUrl => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get cookedCount => integer().withDefault(const Constant(0))();
  IntColumn get defaultServings => integer().withDefault(const Constant(2))();
  IntColumn get rating => integer().withDefault(const Constant(0))(); // 0-5
  DateTimeColumn get lastCookedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get memo => text().withDefault(const Constant(''))();
  
  @override
  List<String> get customConstraints => [
    'UNIQUE (original_id)'
  ];
}

@DataClassName('IngredientEntity')
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get originalId => text()();
  TextColumn get name => text()();
  TextColumn get standardName => text()();
  TextColumn get category => text()();
  TextColumn get unit => text()();
  IntColumn get status => integer()(); // Enum index: 0=toBuy, 1=inCart, 2=stock
  IntColumn get storageType => integer()(); // Enum index: 0=fridge, 1=freezer, 2=room, 3=unknown
  BoolColumn get isEssential => boolean().withDefault(const Constant(false))();
  RealColumn get amount => real().withDefault(const Constant(1.0))();
  DateTimeColumn get purchaseDate => dateTime().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  DateTimeColumn get consumedAt => dateTime().nullable()();

  @override
  List<String> get customConstraints => [
    'UNIQUE (original_id)'
  ];
}

@DataClassName('MealPlanEntity')
class MealPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get originalId => text()();
  TextColumn get recipeId => text()(); // Foreign Key relation logic handled manually or via db constraints if desired
  DateTimeColumn get date => dateTime()();
  IntColumn get mealType => integer()(); // Enum index
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();

  @override
  List<String> get customConstraints => [
    'UNIQUE (original_id)'
  ];
}

@DataClassName('SearchHistoryEntity')
class SearchHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get originalId => text()();
  TextColumn get query => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<String> get customConstraints => [
    'UNIQUE (original_id)'
  ];
}

@DataClassName('UserSettingsEntity')
class UserSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get originalId => text()();
  IntColumn get points => integer().withDefault(const Constant(0))();
  IntColumn get adRights => integer().withDefault(const Constant(0))();
  BoolColumn get contentWifiOnly => boolean().withDefault(const Constant(false))();
  BoolColumn get hideAiIngredientRegistrationDialog => boolean().withDefault(const Constant(false))();
  RealColumn get myAreaLat => real().nullable()();
  RealColumn get myAreaLng => real().nullable()();

  @override
  List<String> get customConstraints => [
    'UNIQUE (original_id)'
  ];
}
