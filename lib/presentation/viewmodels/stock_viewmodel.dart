import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/isar_ingredient_repository.dart';

part 'stock_viewmodel.g.dart';

@riverpod
class StockViewModel extends _$StockViewModel {
  @override
  Future<List<Ingredient>> build() async {
    final repo = await ref.watch(ingredientRepositoryProvider.future);
    final all = await repo.getAll();
    // Filter? Sort by expiry?
    // Requirement: "Default sort by expiry date".
    all.sort((a, b) {
      if (a.expiryDate == null && b.expiryDate == null) return 0;
      if (a.expiryDate == null) return 1;
      if (b.expiryDate == null) return -1;
      return a.expiryDate!.compareTo(b.expiryDate!);
    });
    return all;
  }
}
