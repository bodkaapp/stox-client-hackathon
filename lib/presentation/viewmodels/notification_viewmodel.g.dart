// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationStreamHash() =>
    r'2973257fa129b236a768ed092b7e0a7b76c66dd5';

/// See also [notificationStream].
@ProviderFor(notificationStream)
final notificationStreamProvider =
    AutoDisposeStreamProvider<List<NotificationItem>>.internal(
  notificationStream,
  name: r'notificationStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationStreamRef
    = AutoDisposeStreamProviderRef<List<NotificationItem>>;
String _$markAllAsReadHash() => r'7aaa51e47064212b526c4a26b10a3762fbe1b002';

/// See also [markAllAsRead].
@ProviderFor(markAllAsRead)
final markAllAsReadProvider = AutoDisposeFutureProvider<void>.internal(
  markAllAsRead,
  name: r'markAllAsReadProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$markAllAsReadHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarkAllAsReadRef = AutoDisposeFutureProviderRef<void>;
String _$markAsReadHash() => r'a43c777f95afeb9b1e4e602e048a952a9cd0ed79';

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

/// See also [markAsRead].
@ProviderFor(markAsRead)
const markAsReadProvider = MarkAsReadFamily();

/// See also [markAsRead].
class MarkAsReadFamily extends Family<AsyncValue<void>> {
  /// See also [markAsRead].
  const MarkAsReadFamily();

  /// See also [markAsRead].
  MarkAsReadProvider call(
    int id,
  ) {
    return MarkAsReadProvider(
      id,
    );
  }

  @override
  MarkAsReadProvider getProviderOverride(
    covariant MarkAsReadProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'markAsReadProvider';
}

/// See also [markAsRead].
class MarkAsReadProvider extends AutoDisposeFutureProvider<void> {
  /// See also [markAsRead].
  MarkAsReadProvider(
    int id,
  ) : this._internal(
          (ref) => markAsRead(
            ref as MarkAsReadRef,
            id,
          ),
          from: markAsReadProvider,
          name: r'markAsReadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$markAsReadHash,
          dependencies: MarkAsReadFamily._dependencies,
          allTransitiveDependencies:
              MarkAsReadFamily._allTransitiveDependencies,
          id: id,
        );

  MarkAsReadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<void> Function(MarkAsReadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MarkAsReadProvider._internal(
        (ref) => create(ref as MarkAsReadRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _MarkAsReadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarkAsReadProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarkAsReadRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `id` of this provider.
  int get id;
}

class _MarkAsReadProviderElement extends AutoDisposeFutureProviderElement<void>
    with MarkAsReadRef {
  _MarkAsReadProviderElement(super.provider);

  @override
  int get id => (origin as MarkAsReadProvider).id;
}

String _$addSampleNotificationsHash() =>
    r'd03533e764e47a017f6267d2d50eeb8295106ff8';

/// See also [addSampleNotifications].
@ProviderFor(addSampleNotifications)
final addSampleNotificationsProvider = AutoDisposeFutureProvider<void>.internal(
  addSampleNotifications,
  name: r'addSampleNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addSampleNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddSampleNotificationsRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
