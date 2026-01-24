import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/user_settings.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(UserSettings(id: 'default')) UserSettings userSettings,
    @Default([]) List<Recipe> upcomingMeals,
    @Default([]) List<Ingredient> shoppingList,
    @Default([]) List<Ingredient> expiringIngredients,
    @Default(true) bool isLoading,
  }) = _HomeState;
}
