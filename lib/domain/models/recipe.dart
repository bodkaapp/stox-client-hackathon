import 'package:freezed_annotation/freezed_annotation.dart';
import 'recipe_ingredient.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String title,
    required String pageUrl,
    required String ogpImageUrl,
    required DateTime createdAt,
    @Default(0) int cookedCount,
    @Default(2) int defaultServings,
    @Default(0) int rating,
    DateTime? lastCookedAt,
    @Default(false) bool isDeleted,
    @Default('') String memo,
    @Default([]) List<RecipeIngredient> ingredients,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
