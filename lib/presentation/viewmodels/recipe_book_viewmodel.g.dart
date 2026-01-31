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
String _$pastMenusHash() => r'6fadf323b974d28f4a8ff79f674ce42e93dbf1f4';

/// See also [pastMenus].
@ProviderFor(pastMenus)
final pastMenusProvider = AutoDisposeFutureProvider<List<DailyMenu>>.internal(
  pastMenus,
  name: r'pastMenusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pastMenusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PastMenusRef = AutoDisposeFutureProviderRef<List<DailyMenu>>;
String _$recipeBookViewModelHash() =>
    r'87a3898c69af24c39ab76e7f61f24495d04de663';

/// See also [RecipeBookViewModel].
@ProviderFor(RecipeBookViewModel)
final recipeBookViewModelProvider = AutoDisposeAsyncNotifierProvider<
    RecipeBookViewModel, List<Recipe>>.internal(
  RecipeBookViewModel.new,
  name: r'recipeBookViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recipeBookViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecipeBookViewModel = AutoDisposeAsyncNotifier<List<Recipe>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
