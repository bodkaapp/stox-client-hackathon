import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_ingredient.freezed.dart';
part 'recipe_ingredient.g.dart';

@freezed
class RecipeIngredient with _$RecipeIngredient {
  const factory RecipeIngredient({
    required String name,
    required String amount,
  }) = _RecipeIngredient;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => _$RecipeIngredientFromJson(json);
}
