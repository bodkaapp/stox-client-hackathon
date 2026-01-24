import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/isar_ingredient_repository.dart';
import '../../infrastructure/repositories/isar_user_settings_repository.dart';
import '../providers/shopping_mode_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'shopping_viewmodel.freezed.dart';
part 'shopping_viewmodel.g.dart';

@freezed
class ShoppingState with _$ShoppingState {
  const factory ShoppingState({
    @Default([]) List<Ingredient> toBuyList,
    @Default([]) List<Ingredient> inCartList,
  }) = _ShoppingState;
}

@riverpod
class ShoppingViewModel extends _$ShoppingViewModel {
  @override
  Future<ShoppingState> build() async {
    final repo = await ref.watch(ingredientRepositoryProvider.future);
    
    // Watch relevant streams?
    // Simplified: Just fetch. Real app would listen to streams.
    final all = await repo.getAll();
    
    // Separate by status
    final toBuy = all.where((i) => i.status == IngredientStatus.toBuy).toList();
    final inCart = all.where((i) => i.status == IngredientStatus.inCart).toList();
    
    return ShoppingState(toBuyList: toBuy, inCartList: inCart);
  }

  Future<void> toggleItemStatus(Ingredient item) async {
    final repo = await ref.watch(ingredientRepositoryProvider.future);
    final newStatus = item.status == IngredientStatus.toBuy 
        ? IngredientStatus.inCart 
        : IngredientStatus.toBuy;
        
    final newItem = item.copyWith(status: newStatus);
    await repo.save(newItem);
    
    // Refresh state
    ref.invalidateSelf();
  }

  Future<void> startShopping() async {
    ref.read(shoppingModeProvider.notifier).set(true);
    await WakelockPlus.enable();
  }

  Future<void> finishShopping() async {
    ref.read(shoppingModeProvider.notifier).set(false);
    await WakelockPlus.disable();
    
    // Logic: Move inCart to stock?
    // Or this happens after Receipt Scanning?
    // Requirement: "After shopping, take receipt photo, then 'inCart' -> 'stock'".
    // So "Finish Shopping" button probably triggers the flow:
    // 1. Show Camera/Image Picker
    // 2. On success, update statuses and separate logic.
  }
  
  Future<void> completeShoppingFlow() async {
     // 1. Update statuses
     final repo = await ref.watch(ingredientRepositoryProvider.future);
     final state = await future;
     
     final inCart = state.inCartList;
     for (final item in inCart) {
       await repo.save(item.copyWith(status: IngredientStatus.stock, purchaseDate: DateTime.now()));
     }
     
     // 2. Increment Ad Rights
     final userRepo = await ref.read(userSettingsRepositoryProvider.future);
     final user = await userRepo.get();
     await userRepo.save(user.copyWith(adRights: user.adRights + 1));
     
     await finishShopping();
     ref.invalidateSelf();
  }
}
