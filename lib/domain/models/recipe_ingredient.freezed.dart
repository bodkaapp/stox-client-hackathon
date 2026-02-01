// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_ingredient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) {
  return _RecipeIngredient.fromJson(json);
}

/// @nodoc
mixin _$RecipeIngredient {
  String get name => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;

  /// Serializes this RecipeIngredient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeIngredientCopyWith<RecipeIngredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeIngredientCopyWith<$Res> {
  factory $RecipeIngredientCopyWith(
          RecipeIngredient value, $Res Function(RecipeIngredient) then) =
      _$RecipeIngredientCopyWithImpl<$Res, RecipeIngredient>;
  @useResult
  $Res call({String name, String amount});
}

/// @nodoc
class _$RecipeIngredientCopyWithImpl<$Res, $Val extends RecipeIngredient>
    implements $RecipeIngredientCopyWith<$Res> {
  _$RecipeIngredientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeIngredientImplCopyWith<$Res>
    implements $RecipeIngredientCopyWith<$Res> {
  factory _$$RecipeIngredientImplCopyWith(_$RecipeIngredientImpl value,
          $Res Function(_$RecipeIngredientImpl) then) =
      __$$RecipeIngredientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String amount});
}

/// @nodoc
class __$$RecipeIngredientImplCopyWithImpl<$Res>
    extends _$RecipeIngredientCopyWithImpl<$Res, _$RecipeIngredientImpl>
    implements _$$RecipeIngredientImplCopyWith<$Res> {
  __$$RecipeIngredientImplCopyWithImpl(_$RecipeIngredientImpl _value,
      $Res Function(_$RecipeIngredientImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
  }) {
    return _then(_$RecipeIngredientImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeIngredientImpl implements _RecipeIngredient {
  const _$RecipeIngredientImpl({required this.name, required this.amount});

  factory _$RecipeIngredientImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeIngredientImplFromJson(json);

  @override
  final String name;
  @override
  final String amount;

  @override
  String toString() {
    return 'RecipeIngredient(name: $name, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeIngredientImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, amount);

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeIngredientImplCopyWith<_$RecipeIngredientImpl> get copyWith =>
      __$$RecipeIngredientImplCopyWithImpl<_$RecipeIngredientImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeIngredientImplToJson(
      this,
    );
  }
}

abstract class _RecipeIngredient implements RecipeIngredient {
  const factory _RecipeIngredient(
      {required final String name,
      required final String amount}) = _$RecipeIngredientImpl;

  factory _RecipeIngredient.fromJson(Map<String, dynamic> json) =
      _$RecipeIngredientImpl.fromJson;

  @override
  String get name;
  @override
  String get amount;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeIngredientImplCopyWith<_$RecipeIngredientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
