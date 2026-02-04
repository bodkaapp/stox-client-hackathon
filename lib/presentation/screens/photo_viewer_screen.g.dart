// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_viewer_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$photoAnalysisByPathHash() =>
    r'd656d7c9a944d9669dbf5ad9fb4c66287d3291fd';

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

/// See also [photoAnalysisByPath].
@ProviderFor(photoAnalysisByPath)
const photoAnalysisByPathProvider = PhotoAnalysisByPathFamily();

/// See also [photoAnalysisByPath].
class PhotoAnalysisByPathFamily extends Family<AsyncValue<PhotoAnalysis?>> {
  /// See also [photoAnalysisByPath].
  const PhotoAnalysisByPathFamily();

  /// See also [photoAnalysisByPath].
  PhotoAnalysisByPathProvider call(
    String path,
  ) {
    return PhotoAnalysisByPathProvider(
      path,
    );
  }

  @override
  PhotoAnalysisByPathProvider getProviderOverride(
    covariant PhotoAnalysisByPathProvider provider,
  ) {
    return call(
      provider.path,
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
  String? get name => r'photoAnalysisByPathProvider';
}

/// See also [photoAnalysisByPath].
class PhotoAnalysisByPathProvider
    extends AutoDisposeStreamProvider<PhotoAnalysis?> {
  /// See also [photoAnalysisByPath].
  PhotoAnalysisByPathProvider(
    String path,
  ) : this._internal(
          (ref) => photoAnalysisByPath(
            ref as PhotoAnalysisByPathRef,
            path,
          ),
          from: photoAnalysisByPathProvider,
          name: r'photoAnalysisByPathProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$photoAnalysisByPathHash,
          dependencies: PhotoAnalysisByPathFamily._dependencies,
          allTransitiveDependencies:
              PhotoAnalysisByPathFamily._allTransitiveDependencies,
          path: path,
        );

  PhotoAnalysisByPathProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
  }) : super.internal();

  final String path;

  @override
  Override overrideWith(
    Stream<PhotoAnalysis?> Function(PhotoAnalysisByPathRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PhotoAnalysisByPathProvider._internal(
        (ref) => create(ref as PhotoAnalysisByPathRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<PhotoAnalysis?> createElement() {
    return _PhotoAnalysisByPathProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PhotoAnalysisByPathProvider && other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PhotoAnalysisByPathRef on AutoDisposeStreamProviderRef<PhotoAnalysis?> {
  /// The parameter `path` of this provider.
  String get path;
}

class _PhotoAnalysisByPathProviderElement
    extends AutoDisposeStreamProviderElement<PhotoAnalysis?>
    with PhotoAnalysisByPathRef {
  _PhotoAnalysisByPathProviderElement(super.provider);

  @override
  String get path => (origin as PhotoAnalysisByPathProvider).path;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
