import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

enum IngredientStatus {
  toBuy,   // 買う
  inCart,  // カゴ
  stock,   // 在庫
}

enum StorageType {
  fridge,  // 冷蔵
  freezer, // 冷凍
  room,    // 常温
  unknown,
}

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String id,
    required String name,
    required String standardName,
    required String category,
    required String unit,
    @Default(IngredientStatus.toBuy) IngredientStatus status,
    @Default(StorageType.unknown) StorageType storageType,
    @Default(false) bool isEssential,
    @Default(1.0) double amount,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    DateTime? consumedAt,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);
}
