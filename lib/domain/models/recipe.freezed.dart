// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return _Recipe.fromJson(json);
}

/// @nodoc
mixin _$Recipe {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get pageUrl => throw _privateConstructorUsedError;
  String get ogpImageUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get cookedCount => throw _privateConstructorUsedError;
  int get defaultServings => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  DateTime? get lastCookedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  List<RecipeIngredient> get ingredients => throw _privateConstructorUsedError;

  /// Serializes this Recipe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeCopyWith<Recipe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeCopyWith<$Res> {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) then) =
      _$RecipeCopyWithImpl<$Res, Recipe>;
  @useResult
  $Res call(
      {String id,
      String title,
      String pageUrl,
      String ogpImageUrl,
      DateTime createdAt,
      int cookedCount,
      int defaultServings,
      int rating,
      DateTime? lastCookedAt,
      bool isDeleted,
      String memo,
      List<RecipeIngredient> ingredients});
}

/// @nodoc
class _$RecipeCopyWithImpl<$Res, $Val extends Recipe>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? pageUrl = null,
    Object? ogpImageUrl = null,
    Object? createdAt = null,
    Object? cookedCount = null,
    Object? defaultServings = null,
    Object? rating = null,
    Object? lastCookedAt = freezed,
    Object? isDeleted = null,
    Object? memo = null,
    Object? ingredients = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      pageUrl: null == pageUrl
          ? _value.pageUrl
          : pageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      ogpImageUrl: null == ogpImageUrl
          ? _value.ogpImageUrl
          : ogpImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cookedCount: null == cookedCount
          ? _value.cookedCount
          : cookedCount // ignore: cast_nullable_to_non_nullable
              as int,
      defaultServings: null == defaultServings
          ? _value.defaultServings
          : defaultServings // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      lastCookedAt: freezed == lastCookedAt
          ? _value.lastCookedAt
          : lastCookedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<RecipeIngredient>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeImplCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$$RecipeImplCopyWith(
          _$RecipeImpl value, $Res Function(_$RecipeImpl) then) =
      __$$RecipeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String pageUrl,
      String ogpImageUrl,
      DateTime createdAt,
      int cookedCount,
      int defaultServings,
      int rating,
      DateTime? lastCookedAt,
      bool isDeleted,
      String memo,
      List<RecipeIngredient> ingredients});
}

/// @nodoc
class __$$RecipeImplCopyWithImpl<$Res>
    extends _$RecipeCopyWithImpl<$Res, _$RecipeImpl>
    implements _$$RecipeImplCopyWith<$Res> {
  __$$RecipeImplCopyWithImpl(
      _$RecipeImpl _value, $Res Function(_$RecipeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? pageUrl = null,
    Object? ogpImageUrl = null,
    Object? createdAt = null,
    Object? cookedCount = null,
    Object? defaultServings = null,
    Object? rating = null,
    Object? lastCookedAt = freezed,
    Object? isDeleted = null,
    Object? memo = null,
    Object? ingredients = null,
  }) {
    return _then(_$RecipeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      pageUrl: null == pageUrl
          ? _value.pageUrl
          : pageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      ogpImageUrl: null == ogpImageUrl
          ? _value.ogpImageUrl
          : ogpImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cookedCount: null == cookedCount
          ? _value.cookedCount
          : cookedCount // ignore: cast_nullable_to_non_nullable
              as int,
      defaultServings: null == defaultServings
          ? _value.defaultServings
          : defaultServings // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      lastCookedAt: freezed == lastCookedAt
          ? _value.lastCookedAt
          : lastCookedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<RecipeIngredient>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeImpl implements _Recipe {
  const _$RecipeImpl(
      {required this.id,
      required this.title,
      required this.pageUrl,
      required this.ogpImageUrl,
      required this.createdAt,
      this.cookedCount = 0,
      this.defaultServings = 2,
      this.rating = 0,
      this.lastCookedAt,
      this.isDeleted = false,
      this.memo = '',
      final List<RecipeIngredient> ingredients = const []})
      : _ingredients = ingredients;

  factory _$RecipeImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String pageUrl;
  @override
  final String ogpImageUrl;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int cookedCount;
  @override
  @JsonKey()
  final int defaultServings;
  @override
  @JsonKey()
  final int rating;
  @override
  final DateTime? lastCookedAt;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final String memo;
  final List<RecipeIngredient> _ingredients;
  @override
  @JsonKey()
  List<RecipeIngredient> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, pageUrl: $pageUrl, ogpImageUrl: $ogpImageUrl, createdAt: $createdAt, cookedCount: $cookedCount, defaultServings: $defaultServings, rating: $rating, lastCookedAt: $lastCookedAt, isDeleted: $isDeleted, memo: $memo, ingredients: $ingredients)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.pageUrl, pageUrl) || other.pageUrl == pageUrl) &&
            (identical(other.ogpImageUrl, ogpImageUrl) ||
                other.ogpImageUrl == ogpImageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.cookedCount, cookedCount) ||
                other.cookedCount == cookedCount) &&
            (identical(other.defaultServings, defaultServings) ||
                other.defaultServings == defaultServings) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.lastCookedAt, lastCookedAt) ||
                other.lastCookedAt == lastCookedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      pageUrl,
      ogpImageUrl,
      createdAt,
      cookedCount,
      defaultServings,
      rating,
      lastCookedAt,
      isDeleted,
      memo,
      const DeepCollectionEquality().hash(_ingredients));

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      __$$RecipeImplCopyWithImpl<_$RecipeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeImplToJson(
      this,
    );
  }
}

abstract class _Recipe implements Recipe {
  const factory _Recipe(
      {required final String id,
      required final String title,
      required final String pageUrl,
      required final String ogpImageUrl,
      required final DateTime createdAt,
      final int cookedCount,
      final int defaultServings,
      final int rating,
      final DateTime? lastCookedAt,
      final bool isDeleted,
      final String memo,
      final List<RecipeIngredient> ingredients}) = _$RecipeImpl;

  factory _Recipe.fromJson(Map<String, dynamic> json) = _$RecipeImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get pageUrl;
  @override
  String get ogpImageUrl;
  @override
  DateTime get createdAt;
  @override
  int get cookedCount;
  @override
  int get defaultServings;
  @override
  int get rating;
  @override
  DateTime? get lastCookedAt;
  @override
  bool get isDeleted;
  @override
  String get memo;
  @override
  List<RecipeIngredient> get ingredients;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
