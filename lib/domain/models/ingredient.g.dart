// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IngredientImpl _$$IngredientImplFromJson(Map<String, dynamic> json) =>
    _$IngredientImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      standardName: json['standardName'] as String,
      category: json['category'] as String,
      unit: json['unit'] as String,
      status: $enumDecodeNullable(_$IngredientStatusEnumMap, json['status']) ??
          IngredientStatus.toBuy,
      storageType:
          $enumDecodeNullable(_$StorageTypeEnumMap, json['storageType']) ??
              StorageType.unknown,
      isEssential: json['isEssential'] as bool? ?? false,
      amount: (json['amount'] as num?)?.toDouble() ?? 1.0,
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      consumedAt: json['consumedAt'] == null
          ? null
          : DateTime.parse(json['consumedAt'] as String),
    );

Map<String, dynamic> _$$IngredientImplToJson(_$IngredientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'standardName': instance.standardName,
      'category': instance.category,
      'unit': instance.unit,
      'status': _$IngredientStatusEnumMap[instance.status]!,
      'storageType': _$StorageTypeEnumMap[instance.storageType]!,
      'isEssential': instance.isEssential,
      'amount': instance.amount,
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'consumedAt': instance.consumedAt?.toIso8601String(),
    };

const _$IngredientStatusEnumMap = {
  IngredientStatus.toBuy: 'toBuy',
  IngredientStatus.inCart: 'inCart',
  IngredientStatus.stock: 'stock',
};

const _$StorageTypeEnumMap = {
  StorageType.fridge: 'fridge',
  StorageType.freezer: 'freezer',
  StorageType.room: 'room',
  StorageType.unknown: 'unknown',
};
