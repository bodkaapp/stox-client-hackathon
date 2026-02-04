import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../infrastructure/repositories/drift_recipe_repository.dart';

part 'recently_viewed_recipes_viewmodel.g.dart';

// --- Recently Added Recipes (Created Date Desc) ---

@riverpod
class RecentlyAddedRecipes extends _$RecentlyAddedRecipes {
  bool _hasMore = true;
  static const int _limit = 50;

  bool get hasMore => _hasMore;

  @override
  FutureOr<List<Recipe>> build() async {
    _hasMore = true;
    return _fetch(offset: 0);
  }

  Future<List<Recipe>> _fetch({required int offset}) async {
    final repo = await ref.watch(recipeRepositoryProvider.future);
    final newItems = await repo.getRecent(limit: _limit, offset: offset);
    if (newItems.length < _limit) {
      _hasMore = false;
    }
    return newItems;
  }

  Future<void> loadMore() async {
    final currentList = state.valueOrNull;
    if (currentList == null || !_hasMore || state.isLoading) return;

    state = const AsyncLoading<List<Recipe>>().copyWithPrevious(state);

    try {
      final newItems = await _fetch(offset: currentList.length);
      state = AsyncData([...currentList, ...newItems]);
    } catch (e, s) {
      state = AsyncError<List<Recipe>>(e, s).copyWithPrevious(state);
    }
  }
}

// --- Recently Viewed Recipes (Last Viewed Date Desc) ---

@riverpod
class RecentlyViewedRecipes extends _$RecentlyViewedRecipes {
  bool _hasMore = true;
  static const int _limit = 50;

  bool get hasMore => _hasMore;

  @override
  FutureOr<List<Recipe>> build() async {
    _hasMore = true;
    return _fetch(offset: 0);
  }

  Future<List<Recipe>> _fetch({required int offset}) async {
    final repo = await ref.watch(recipeRepositoryProvider.future);
    final newItems = await repo.getRecentlyViewed(limit: _limit, offset: offset);
    if (newItems.length < _limit) {
      _hasMore = false;
    }
    return newItems;
  }

  Future<void> loadMore() async {
    final currentList = state.valueOrNull;
    if (currentList == null || !_hasMore || state.isLoading) return;

    state = const AsyncLoading<List<Recipe>>().copyWithPrevious(state);

    try {
      final newItems = await _fetch(offset: currentList.length);
      state = AsyncData([...currentList, ...newItems]);
    } catch (e, s) {
      state = AsyncError<List<Recipe>>(e, s).copyWithPrevious(state);
    }
  }
}
