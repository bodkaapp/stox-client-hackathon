// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_book_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todaysMenuHash() => r'c44572e266394ba0878f8b944c4231213cb716a0';

/// See also [todaysMenu].
@ProviderFor(todaysMenu)
final todaysMenuProvider = AutoDisposeStreamProvider<List<Recipe>>.internal(
  todaysMenu,
  name: r'todaysMenuProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todaysMenuHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodaysMenuRef = AutoDisposeStreamProviderRef<List<Recipe>>;
String _$pastMenusHash() => r'bee904e46b80f155aeb708e9fd30733db19fef07';

/// See also [pastMenus].
@ProviderFor(pastMenus)
final pastMenusProvider = AutoDisposeStreamProvider<List<DailyMenu>>.internal(
  pastMenus,
  name: r'pastMenusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pastMenusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PastMenusRef = AutoDisposeStreamProviderRef<List<DailyMenu>>;
String _$recipeBookViewModelHash() =>
    r'4b1eab79de84821d999add78181e4d462aff8588';

/// See also [RecipeBookViewModel].
@ProviderFor(RecipeBookViewModel)
final recipeBookViewModelProvider = AutoDisposeStreamNotifierProvider<
    RecipeBookViewModel, List<Recipe>>.internal(
  RecipeBookViewModel.new,
  name: r'recipeBookViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recipeBookViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecipeBookViewModel = AutoDisposeStreamNotifier<List<Recipe>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
