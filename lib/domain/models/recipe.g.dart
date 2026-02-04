// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeImpl _$$RecipeImplFromJson(Map<String, dynamic> json) => _$RecipeImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      pageUrl: json['pageUrl'] as String,
      ogpImageUrl: json['ogpImageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      cookedCount: (json['cookedCount'] as num?)?.toInt() ?? 0,
      defaultServings: (json['defaultServings'] as num?)?.toInt() ?? 2,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      lastCookedAt: json['lastCookedAt'] == null
          ? null
          : DateTime.parse(json['lastCookedAt'] as String),
      lastViewedAt: json['lastViewedAt'] == null
          ? null
          : DateTime.parse(json['lastViewedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
      isTemporary: json['isTemporary'] as bool? ?? false,
      memo: json['memo'] as String? ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RecipeImplToJson(_$RecipeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'pageUrl': instance.pageUrl,
      'ogpImageUrl': instance.ogpImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'cookedCount': instance.cookedCount,
      'defaultServings': instance.defaultServings,
      'rating': instance.rating,
      'lastCookedAt': instance.lastCookedAt?.toIso8601String(),
      'lastViewedAt': instance.lastViewedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'isTemporary': instance.isTemporary,
      'memo': instance.memo,
      'ingredients': instance.ingredients,
    };
