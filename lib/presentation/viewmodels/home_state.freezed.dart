// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeState {
  UserSettings get userSettings => throw _privateConstructorUsedError;
  List<Recipe> get upcomingMeals => throw _privateConstructorUsedError;
  List<Ingredient> get shoppingList => throw _privateConstructorUsedError;
  List<Ingredient> get expiringIngredients =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {UserSettings userSettings,
      List<Recipe> upcomingMeals,
      List<Ingredient> shoppingList,
      List<Ingredient> expiringIngredients,
      bool isLoading});

  $UserSettingsCopyWith<$Res> get userSettings;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userSettings = null,
    Object? upcomingMeals = null,
    Object? shoppingList = null,
    Object? expiringIngredients = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      userSettings: null == userSettings
          ? _value.userSettings
          : userSettings // ignore: cast_nullable_to_non_nullable
              as UserSettings,
      upcomingMeals: null == upcomingMeals
          ? _value.upcomingMeals
          : upcomingMeals // ignore: cast_nullable_to_non_nullable
              as List<Recipe>,
      shoppingList: null == shoppingList
          ? _value.shoppingList
          : shoppingList // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      expiringIngredients: null == expiringIngredients
          ? _value.expiringIngredients
          : expiringIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserSettingsCopyWith<$Res> get userSettings {
    return $UserSettingsCopyWith<$Res>(_value.userSettings, (value) {
      return _then(_value.copyWith(userSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserSettings userSettings,
      List<Recipe> upcomingMeals,
      List<Ingredient> shoppingList,
      List<Ingredient> expiringIngredients,
      bool isLoading});

  @override
  $UserSettingsCopyWith<$Res> get userSettings;
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userSettings = null,
    Object? upcomingMeals = null,
    Object? shoppingList = null,
    Object? expiringIngredients = null,
    Object? isLoading = null,
  }) {
    return _then(_$HomeStateImpl(
      userSettings: null == userSettings
          ? _value.userSettings
          : userSettings // ignore: cast_nullable_to_non_nullable
              as UserSettings,
      upcomingMeals: null == upcomingMeals
          ? _value._upcomingMeals
          : upcomingMeals // ignore: cast_nullable_to_non_nullable
              as List<Recipe>,
      shoppingList: null == shoppingList
          ? _value._shoppingList
          : shoppingList // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      expiringIngredients: null == expiringIngredients
          ? _value._expiringIngredients
          : expiringIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl(
      {this.userSettings = const UserSettings(id: 'default'),
      final List<Recipe> upcomingMeals = const [],
      final List<Ingredient> shoppingList = const [],
      final List<Ingredient> expiringIngredients = const [],
      this.isLoading = true})
      : _upcomingMeals = upcomingMeals,
        _shoppingList = shoppingList,
        _expiringIngredients = expiringIngredients;

  @override
  @JsonKey()
  final UserSettings userSettings;
  final List<Recipe> _upcomingMeals;
  @override
  @JsonKey()
  List<Recipe> get upcomingMeals {
    if (_upcomingMeals is EqualUnmodifiableListView) return _upcomingMeals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upcomingMeals);
  }

  final List<Ingredient> _shoppingList;
  @override
  @JsonKey()
  List<Ingredient> get shoppingList {
    if (_shoppingList is EqualUnmodifiableListView) return _shoppingList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shoppingList);
  }

  final List<Ingredient> _expiringIngredients;
  @override
  @JsonKey()
  List<Ingredient> get expiringIngredients {
    if (_expiringIngredients is EqualUnmodifiableListView)
      return _expiringIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expiringIngredients);
  }

  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'HomeState(userSettings: $userSettings, upcomingMeals: $upcomingMeals, shoppingList: $shoppingList, expiringIngredients: $expiringIngredients, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.userSettings, userSettings) ||
                other.userSettings == userSettings) &&
            const DeepCollectionEquality()
                .equals(other._upcomingMeals, _upcomingMeals) &&
            const DeepCollectionEquality()
                .equals(other._shoppingList, _shoppingList) &&
            const DeepCollectionEquality()
                .equals(other._expiringIngredients, _expiringIngredients) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userSettings,
      const DeepCollectionEquality().hash(_upcomingMeals),
      const DeepCollectionEquality().hash(_shoppingList),
      const DeepCollectionEquality().hash(_expiringIngredients),
      isLoading);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {final UserSettings userSettings,
      final List<Recipe> upcomingMeals,
      final List<Ingredient> shoppingList,
      final List<Ingredient> expiringIngredients,
      final bool isLoading}) = _$HomeStateImpl;

  @override
  UserSettings get userSettings;
  @override
  List<Recipe> get upcomingMeals;
  @override
  List<Ingredient> get shoppingList;
  @override
  List<Ingredient> get expiringIngredients;
  @override
  bool get isLoading;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
