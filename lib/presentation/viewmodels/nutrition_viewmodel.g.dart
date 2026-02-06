// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealNutritionalSummaryHash() =>
    r'3f8dbf7494b78c58547126d3d7d462553c50fa08';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [mealNutritionalSummary].
@ProviderFor(mealNutritionalSummary)
const mealNutritionalSummaryProvider = MealNutritionalSummaryFamily();

/// See also [mealNutritionalSummary].
class MealNutritionalSummaryFamily
    extends Family<AsyncValue<NutritionalSummary>> {
  /// See also [mealNutritionalSummary].
  const MealNutritionalSummaryFamily();

  /// See also [mealNutritionalSummary].
  MealNutritionalSummaryProvider call(
    List<String> photoPaths,
  ) {
    return MealNutritionalSummaryProvider(
      photoPaths,
    );
  }

  @override
  MealNutritionalSummaryProvider getProviderOverride(
    covariant MealNutritionalSummaryProvider provider,
  ) {
    return call(
      provider.photoPaths,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mealNutritionalSummaryProvider';
}

/// See also [mealNutritionalSummary].
class MealNutritionalSummaryProvider
    extends AutoDisposeFutureProvider<NutritionalSummary> {
  /// See also [mealNutritionalSummary].
  MealNutritionalSummaryProvider(
    List<String> photoPaths,
  ) : this._internal(
          (ref) => mealNutritionalSummary(
            ref as MealNutritionalSummaryRef,
            photoPaths,
          ),
          from: mealNutritionalSummaryProvider,
          name: r'mealNutritionalSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mealNutritionalSummaryHash,
          dependencies: MealNutritionalSummaryFamily._dependencies,
          allTransitiveDependencies:
              MealNutritionalSummaryFamily._allTransitiveDependencies,
          photoPaths: photoPaths,
        );

  MealNutritionalSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.photoPaths,
  }) : super.internal();

  final List<String> photoPaths;

  @override
  Override overrideWith(
    FutureOr<NutritionalSummary> Function(MealNutritionalSummaryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MealNutritionalSummaryProvider._internal(
        (ref) => create(ref as MealNutritionalSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        photoPaths: photoPaths,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<NutritionalSummary> createElement() {
    return _MealNutritionalSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealNutritionalSummaryProvider &&
        other.photoPaths == photoPaths;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, photoPaths.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MealNutritionalSummaryRef
    on AutoDisposeFutureProviderRef<NutritionalSummary> {
  /// The parameter `photoPaths` of this provider.
  List<String> get photoPaths;
}

class _MealNutritionalSummaryProviderElement
    extends AutoDisposeFutureProviderElement<NutritionalSummary>
    with MealNutritionalSummaryRef {
  _MealNutritionalSummaryProviderElement(super.provider);

  @override
  List<String> get photoPaths =>
      (origin as MealNutritionalSummaryProvider).photoPaths;
}

String _$dailyNutritionalSummaryHash() =>
    r'c3173bddc66d4a28cf23f18b1edb18ebed96f62b';

/// See also [dailyNutritionalSummary].
@ProviderFor(dailyNutritionalSummary)
const dailyNutritionalSummaryProvider = DailyNutritionalSummaryFamily();

/// See also [dailyNutritionalSummary].
class DailyNutritionalSummaryFamily
    extends Family<AsyncValue<NutritionalSummary>> {
  /// See also [dailyNutritionalSummary].
  const DailyNutritionalSummaryFamily();

  /// See also [dailyNutritionalSummary].
  DailyNutritionalSummaryProvider call(
    List<MealPlan> mealPlans,
  ) {
    return DailyNutritionalSummaryProvider(
      mealPlans,
    );
  }

  @override
  DailyNutritionalSummaryProvider getProviderOverride(
    covariant DailyNutritionalSummaryProvider provider,
  ) {
    return call(
      provider.mealPlans,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dailyNutritionalSummaryProvider';
}

/// See also [dailyNutritionalSummary].
class DailyNutritionalSummaryProvider
    extends AutoDisposeFutureProvider<NutritionalSummary> {
  /// See also [dailyNutritionalSummary].
  DailyNutritionalSummaryProvider(
    List<MealPlan> mealPlans,
  ) : this._internal(
          (ref) => dailyNutritionalSummary(
            ref as DailyNutritionalSummaryRef,
            mealPlans,
          ),
          from: dailyNutritionalSummaryProvider,
          name: r'dailyNutritionalSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dailyNutritionalSummaryHash,
          dependencies: DailyNutritionalSummaryFamily._dependencies,
          allTransitiveDependencies:
              DailyNutritionalSummaryFamily._allTransitiveDependencies,
          mealPlans: mealPlans,
        );

  DailyNutritionalSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mealPlans,
  }) : super.internal();

  final List<MealPlan> mealPlans;

  @override
  Override overrideWith(
    FutureOr<NutritionalSummary> Function(DailyNutritionalSummaryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyNutritionalSummaryProvider._internal(
        (ref) => create(ref as DailyNutritionalSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mealPlans: mealPlans,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<NutritionalSummary> createElement() {
    return _DailyNutritionalSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyNutritionalSummaryProvider &&
        other.mealPlans == mealPlans;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mealPlans.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DailyNutritionalSummaryRef
    on AutoDisposeFutureProviderRef<NutritionalSummary> {
  /// The parameter `mealPlans` of this provider.
  List<MealPlan> get mealPlans;
}

class _DailyNutritionalSummaryProviderElement
    extends AutoDisposeFutureProviderElement<NutritionalSummary>
    with DailyNutritionalSummaryRef {
  _DailyNutritionalSummaryProviderElement(super.provider);

  @override
  List<MealPlan> get mealPlans =>
      (origin as DailyNutritionalSummaryProvider).mealPlans;
}

String _$dailyDetailedNutritionalSummaryHash() =>
    r'd3d0b21bea5d992402afe2eadc6f41e11083f734';

/// See also [dailyDetailedNutritionalSummary].
@ProviderFor(dailyDetailedNutritionalSummary)
const dailyDetailedNutritionalSummaryProvider =
    DailyDetailedNutritionalSummaryFamily();

/// See also [dailyDetailedNutritionalSummary].
class DailyDetailedNutritionalSummaryFamily
    extends Family<AsyncValue<Map<MealType, NutritionalSummary>>> {
  /// See also [dailyDetailedNutritionalSummary].
  const DailyDetailedNutritionalSummaryFamily();

  /// See also [dailyDetailedNutritionalSummary].
  DailyDetailedNutritionalSummaryProvider call(
    List<MealPlan> mealPlans,
  ) {
    return DailyDetailedNutritionalSummaryProvider(
      mealPlans,
    );
  }

  @override
  DailyDetailedNutritionalSummaryProvider getProviderOverride(
    covariant DailyDetailedNutritionalSummaryProvider provider,
  ) {
    return call(
      provider.mealPlans,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dailyDetailedNutritionalSummaryProvider';
}

/// See also [dailyDetailedNutritionalSummary].
class DailyDetailedNutritionalSummaryProvider
    extends AutoDisposeFutureProvider<Map<MealType, NutritionalSummary>> {
  /// See also [dailyDetailedNutritionalSummary].
  DailyDetailedNutritionalSummaryProvider(
    List<MealPlan> mealPlans,
  ) : this._internal(
          (ref) => dailyDetailedNutritionalSummary(
            ref as DailyDetailedNutritionalSummaryRef,
            mealPlans,
          ),
          from: dailyDetailedNutritionalSummaryProvider,
          name: r'dailyDetailedNutritionalSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dailyDetailedNutritionalSummaryHash,
          dependencies: DailyDetailedNutritionalSummaryFamily._dependencies,
          allTransitiveDependencies:
              DailyDetailedNutritionalSummaryFamily._allTransitiveDependencies,
          mealPlans: mealPlans,
        );

  DailyDetailedNutritionalSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mealPlans,
  }) : super.internal();

  final List<MealPlan> mealPlans;

  @override
  Override overrideWith(
    FutureOr<Map<MealType, NutritionalSummary>> Function(
            DailyDetailedNutritionalSummaryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyDetailedNutritionalSummaryProvider._internal(
        (ref) => create(ref as DailyDetailedNutritionalSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mealPlans: mealPlans,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<MealType, NutritionalSummary>>
      createElement() {
    return _DailyDetailedNutritionalSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyDetailedNutritionalSummaryProvider &&
        other.mealPlans == mealPlans;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mealPlans.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DailyDetailedNutritionalSummaryRef
    on AutoDisposeFutureProviderRef<Map<MealType, NutritionalSummary>> {
  /// The parameter `mealPlans` of this provider.
  List<MealPlan> get mealPlans;
}

class _DailyDetailedNutritionalSummaryProviderElement
    extends AutoDisposeFutureProviderElement<Map<MealType, NutritionalSummary>>
    with DailyDetailedNutritionalSummaryRef {
  _DailyDetailedNutritionalSummaryProviderElement(super.provider);

  @override
  List<MealPlan> get mealPlans =>
      (origin as DailyDetailedNutritionalSummaryProvider).mealPlans;
}

String _$averageNutritionalSummaryHash() =>
    r'2561d2d8fbdb03186fbbb11f9a8303f6d560e91b';

/// See also [averageNutritionalSummary].
@ProviderFor(averageNutritionalSummary)
const averageNutritionalSummaryProvider = AverageNutritionalSummaryFamily();

/// See also [averageNutritionalSummary].
class AverageNutritionalSummaryFamily
    extends Family<AsyncValue<NutritionalSummary>> {
  /// See also [averageNutritionalSummary].
  const AverageNutritionalSummaryFamily();

  /// See also [averageNutritionalSummary].
  AverageNutritionalSummaryProvider call({
    required int days,
  }) {
    return AverageNutritionalSummaryProvider(
      days: days,
    );
  }

  @override
  AverageNutritionalSummaryProvider getProviderOverride(
    covariant AverageNutritionalSummaryProvider provider,
  ) {
    return call(
      days: provider.days,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'averageNutritionalSummaryProvider';
}

/// See also [averageNutritionalSummary].
class AverageNutritionalSummaryProvider
    extends AutoDisposeFutureProvider<NutritionalSummary> {
  /// See also [averageNutritionalSummary].
  AverageNutritionalSummaryProvider({
    required int days,
  }) : this._internal(
          (ref) => averageNutritionalSummary(
            ref as AverageNutritionalSummaryRef,
            days: days,
          ),
          from: averageNutritionalSummaryProvider,
          name: r'averageNutritionalSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$averageNutritionalSummaryHash,
          dependencies: AverageNutritionalSummaryFamily._dependencies,
          allTransitiveDependencies:
              AverageNutritionalSummaryFamily._allTransitiveDependencies,
          days: days,
        );

  AverageNutritionalSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    FutureOr<NutritionalSummary> Function(AverageNutritionalSummaryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AverageNutritionalSummaryProvider._internal(
        (ref) => create(ref as AverageNutritionalSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<NutritionalSummary> createElement() {
    return _AverageNutritionalSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AverageNutritionalSummaryProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AverageNutritionalSummaryRef
    on AutoDisposeFutureProviderRef<NutritionalSummary> {
  /// The parameter `days` of this provider.
  int get days;
}

class _AverageNutritionalSummaryProviderElement
    extends AutoDisposeFutureProviderElement<NutritionalSummary>
    with AverageNutritionalSummaryRef {
  _AverageNutritionalSummaryProviderElement(super.provider);

  @override
  int get days => (origin as AverageNutritionalSummaryProvider).days;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
