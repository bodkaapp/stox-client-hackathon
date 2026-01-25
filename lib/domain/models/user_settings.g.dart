// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      id: json['id'] as String,
      points: (json['points'] as num?)?.toInt() ?? 0,
      adRights: (json['adRights'] as num?)?.toInt() ?? 0,
      contentWifiOnly: json['contentWifiOnly'] as bool? ?? false,
      myAreaLat: (json['myAreaLat'] as num?)?.toDouble(),
      myAreaLng: (json['myAreaLng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'points': instance.points,
      'adRights': instance.adRights,
      'contentWifiOnly': instance.contentWifiOnly,
      'myAreaLat': instance.myAreaLat,
      'myAreaLng': instance.myAreaLng,
    };
