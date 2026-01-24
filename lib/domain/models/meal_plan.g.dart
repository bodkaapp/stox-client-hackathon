// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealPlanImpl _$$MealPlanImplFromJson(Map<String, dynamic> json) =>
    _$MealPlanImpl(
      id: json['id'] as String,
      recipeId: json['recipeId'] as String,
      date: DateTime.parse(json['date'] as String),
      mealType: $enumDecode(_$MealTypeEnumMap, json['mealType']),
      isDone: json['isDone'] as bool? ?? false,
    );

Map<String, dynamic> _$$MealPlanImplToJson(_$MealPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipeId': instance.recipeId,
      'date': instance.date.toIso8601String(),
      'mealType': _$MealTypeEnumMap[instance.mealType]!,
      'isDone': instance.isDone,
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
  MealType.snack: 'snack',
  MealType.preMade: 'preMade',
  MealType.other: 'other',
};
