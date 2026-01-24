import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../infrastructure/repositories/isar_recipe_repository.dart';
import '../../infrastructure/repositories/isar_ingredient_repository.dart';
import '../../infrastructure/repositories/isar_user_settings_repository.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/ingredient.dart';
import 'home_state.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeState> build() async {
    // Watch repositories
    final userRepo = await ref.watch(userSettingsRepositoryProvider.future);
    final ingredientRepo = await ref.watch(ingredientRepositoryProvider.future);
    final recipeRepo = await ref.watch(recipeRepositoryProvider.future);

    // Initial fetch
    final settings = await userRepo.get();
    
    // Listen to streams
    // Ideally we should merge streams, but for simplicity we'll just fetch initial and listen individually if needed
    // or rely on ref.watch of streams provided by repositories if we made them providers.
    
    // For now, let's just return initial state and maybe set up real-time in a better way
    // or manually listen.
    
    // Actually, simpler to just watch the streams if exposed as providers.
    // But repos expose streams via methods.
    
    final shoppingList = await ingredientRepo.getAll(); // Filter for needed?
    final buyingList = shoppingList.where((i) => i.status == IngredientStatus.toBuy).toList();
    
    // Expiring: sorting by date
    final expiring = shoppingList.where((i) => i.expiryDate != null).toList()
      ..sort((a, b) => a.expiryDate!.compareTo(b.expiryDate!));
      
    // Upcoming meals: Mock for now or fetch from MealPlan
    // final upcoming = await ...
    
    return HomeState(
      userSettings: settings,
      shoppingList: buyingList,
      expiringIngredients: expiring.take(5).toList(),
      isLoading: false,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
       return build();
    });
  }
}
