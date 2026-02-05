// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FoodPhoto _$FoodPhotoFromJson(Map<String, dynamic> json) {
  return _FoodPhoto.fromJson(json);
}

/// @nodoc
mixin _$FoodPhoto {
  int get id => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get mealPlanId => throw _privateConstructorUsedError;

  /// Serializes this FoodPhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodPhotoCopyWith<FoodPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodPhotoCopyWith<$Res> {
  factory $FoodPhotoCopyWith(FoodPhoto value, $Res Function(FoodPhoto) then) =
      _$FoodPhotoCopyWithImpl<$Res, FoodPhoto>;
  @useResult
  $Res call({int id, String path, DateTime createdAt, String? mealPlanId});
}

/// @nodoc
class _$FoodPhotoCopyWithImpl<$Res, $Val extends FoodPhoto>
    implements $FoodPhotoCopyWith<$Res> {
  _$FoodPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? createdAt = null,
    Object? mealPlanId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mealPlanId: freezed == mealPlanId
          ? _value.mealPlanId
          : mealPlanId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodPhotoImplCopyWith<$Res>
    implements $FoodPhotoCopyWith<$Res> {
  factory _$$FoodPhotoImplCopyWith(
          _$FoodPhotoImpl value, $Res Function(_$FoodPhotoImpl) then) =
      __$$FoodPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String path, DateTime createdAt, String? mealPlanId});
}

/// @nodoc
class __$$FoodPhotoImplCopyWithImpl<$Res>
    extends _$FoodPhotoCopyWithImpl<$Res, _$FoodPhotoImpl>
    implements _$$FoodPhotoImplCopyWith<$Res> {
  __$$FoodPhotoImplCopyWithImpl(
      _$FoodPhotoImpl _value, $Res Function(_$FoodPhotoImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? createdAt = null,
    Object? mealPlanId = freezed,
  }) {
    return _then(_$FoodPhotoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mealPlanId: freezed == mealPlanId
          ? _value.mealPlanId
          : mealPlanId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodPhotoImpl implements _FoodPhoto {
  const _$FoodPhotoImpl(
      {required this.id,
      required this.path,
      required this.createdAt,
      this.mealPlanId});

  factory _$FoodPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodPhotoImplFromJson(json);

  @override
  final int id;
  @override
  final String path;
  @override
  final DateTime createdAt;
  @override
  final String? mealPlanId;

  @override
  String toString() {
    return 'FoodPhoto(id: $id, path: $path, createdAt: $createdAt, mealPlanId: $mealPlanId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodPhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.mealPlanId, mealPlanId) ||
                other.mealPlanId == mealPlanId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, path, createdAt, mealPlanId);

  /// Create a copy of FoodPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodPhotoImplCopyWith<_$FoodPhotoImpl> get copyWith =>
      __$$FoodPhotoImplCopyWithImpl<_$FoodPhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodPhotoImplToJson(
      this,
    );
  }
}

abstract class _FoodPhoto implements FoodPhoto {
  const factory _FoodPhoto(
      {required final int id,
      required final String path,
      required final DateTime createdAt,
      final String? mealPlanId}) = _$FoodPhotoImpl;

  factory _FoodPhoto.fromJson(Map<String, dynamic> json) =
      _$FoodPhotoImpl.fromJson;

  @override
  int get id;
  @override
  String get path;
  @override
  DateTime get createdAt;
  @override
  String? get mealPlanId;

  /// Create a copy of FoodPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodPhotoImplCopyWith<_$FoodPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
