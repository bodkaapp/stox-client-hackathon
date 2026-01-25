// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchHistoryImpl _$$SearchHistoryImplFromJson(Map<String, dynamic> json) =>
    _$SearchHistoryImpl(
      id: json['id'] as String,
      query: json['query'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SearchHistoryImplToJson(_$SearchHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'query': instance.query,
      'createdAt': instance.createdAt.toIso8601String(),
    };
