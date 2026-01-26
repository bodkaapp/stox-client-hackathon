// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShoppingState {
  List<Ingredient> get toBuyList => throw _privateConstructorUsedError;
  List<Ingredient> get inCartList => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingStateCopyWith<ShoppingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingStateCopyWith<$Res> {
  factory $ShoppingStateCopyWith(
          ShoppingState value, $Res Function(ShoppingState) then) =
      _$ShoppingStateCopyWithImpl<$Res, ShoppingState>;
  @useResult
  $Res call({List<Ingredient> toBuyList, List<Ingredient> inCartList});
}

/// @nodoc
class _$ShoppingStateCopyWithImpl<$Res, $Val extends ShoppingState>
    implements $ShoppingStateCopyWith<$Res> {
  _$ShoppingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toBuyList = null,
    Object? inCartList = null,
  }) {
    return _then(_value.copyWith(
      toBuyList: null == toBuyList
          ? _value.toBuyList
          : toBuyList // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      inCartList: null == inCartList
          ? _value.inCartList
          : inCartList // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShoppingStateImplCopyWith<$Res>
    implements $ShoppingStateCopyWith<$Res> {
  factory _$$ShoppingStateImplCopyWith(
          _$ShoppingStateImpl value, $Res Function(_$ShoppingStateImpl) then) =
      __$$ShoppingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Ingredient> toBuyList, List<Ingredient> inCartList});
}

/// @nodoc
class __$$ShoppingStateImplCopyWithImpl<$Res>
    extends _$ShoppingStateCopyWithImpl<$Res, _$ShoppingStateImpl>
    implements _$$ShoppingStateImplCopyWith<$Res> {
  __$$ShoppingStateImplCopyWithImpl(
      _$ShoppingStateImpl _value, $Res Function(_$ShoppingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShoppingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toBuyList = null,
    Object? inCartList = null,
  }) {
    return _then(_$ShoppingStateImpl(
      toBuyList: null == toBuyList
          ? _value._toBuyList
          : toBuyList // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      inCartList: null == inCartList
          ? _value._inCartList
          : inCartList // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
    ));
  }
}

/// @nodoc

class _$ShoppingStateImpl implements _ShoppingState {
  const _$ShoppingStateImpl(
      {final List<Ingredient> toBuyList = const [],
      final List<Ingredient> inCartList = const []})
      : _toBuyList = toBuyList,
        _inCartList = inCartList;

  final List<Ingredient> _toBuyList;
  @override
  @JsonKey()
  List<Ingredient> get toBuyList {
    if (_toBuyList is EqualUnmodifiableListView) return _toBuyList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_toBuyList);
  }

  final List<Ingredient> _inCartList;
  @override
  @JsonKey()
  List<Ingredient> get inCartList {
    if (_inCartList is EqualUnmodifiableListView) return _inCartList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inCartList);
  }

  @override
  String toString() {
    return 'ShoppingState(toBuyList: $toBuyList, inCartList: $inCartList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingStateImpl &&
            const DeepCollectionEquality()
                .equals(other._toBuyList, _toBuyList) &&
            const DeepCollectionEquality()
                .equals(other._inCartList, _inCartList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_toBuyList),
      const DeepCollectionEquality().hash(_inCartList));

  /// Create a copy of ShoppingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingStateImplCopyWith<_$ShoppingStateImpl> get copyWith =>
      __$$ShoppingStateImplCopyWithImpl<_$ShoppingStateImpl>(this, _$identity);
}

abstract class _ShoppingState implements ShoppingState {
  const factory _ShoppingState(
      {final List<Ingredient> toBuyList,
      final List<Ingredient> inCartList}) = _$ShoppingStateImpl;

  @override
  List<Ingredient> get toBuyList;
  @override
  List<Ingredient> get inCartList;

  /// Create a copy of ShoppingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingStateImplCopyWith<_$ShoppingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
