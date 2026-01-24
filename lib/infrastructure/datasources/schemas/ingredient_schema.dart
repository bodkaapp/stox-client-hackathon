import 'package:isar/isar.dart';

part 'ingredient_schema.g.dart';

// Enums must be compatible with Isar or stored as values.
// Isar 3 supports enums.

@collection
class IngredientCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late String originalId;

  late String name;
  late String standardName;
  late String category;
  late String unit;
  
  @enumerated
  late IngredientStatusSchema status;

  @enumerated
  late StorageTypeSchema storageType;

  bool isEssential = false;
  double amount = 1.0;
  
  DateTime? purchaseDate;
  DateTime? expiryDate;
  DateTime? consumedAt;
}

enum IngredientStatusSchema {
  toBuy,   // 0
  inCart,  // 1
  stock,   // 2
}

enum StorageTypeSchema {
  fridge,  // 0
  freezer, // 1
  room,    // 2
  unknown, // 3
}
