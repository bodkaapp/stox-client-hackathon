// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodPhotoImpl _$$FoodPhotoImplFromJson(Map<String, dynamic> json) =>
    _$FoodPhotoImpl(
      id: (json['id'] as num).toInt(),
      path: json['path'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      mealPlanId: json['mealPlanId'] as String?,
    );

Map<String, dynamic> _$$FoodPhotoImplToJson(_$FoodPhotoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'createdAt': instance.createdAt.toIso8601String(),
      'mealPlanId': instance.mealPlanId,
    };
