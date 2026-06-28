// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failure_mapper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Feature-level scope is wrong here on purpose — every Repository across
/// every feature needs the same mapping behavior, so this is one of the
/// few providers that's intentionally app-wide rather than scoped.
///
/// Previously a hand-written `Provider<FailureMapper>(...)` — converted to
/// codegen so every app-wide provider in Core follows the same declaration
/// pattern as `connectivityProvider` / `dioProvider`, instead of mixing
/// manual and generated providers for the same kind of job. See
/// `core/logging/talker_provider.dart` for the one deliberate, documented
/// exception to this convention.

@ProviderFor(failureMapper)
final failureMapperProvider = FailureMapperProvider._();

/// Feature-level scope is wrong here on purpose — every Repository across
/// every feature needs the same mapping behavior, so this is one of the
/// few providers that's intentionally app-wide rather than scoped.
///
/// Previously a hand-written `Provider<FailureMapper>(...)` — converted to
/// codegen so every app-wide provider in Core follows the same declaration
/// pattern as `connectivityProvider` / `dioProvider`, instead of mixing
/// manual and generated providers for the same kind of job. See
/// `core/logging/talker_provider.dart` for the one deliberate, documented
/// exception to this convention.

final class FailureMapperProvider
    extends $FunctionalProvider<FailureMapper, FailureMapper, FailureMapper>
    with $Provider<FailureMapper> {
  /// Feature-level scope is wrong here on purpose — every Repository across
  /// every feature needs the same mapping behavior, so this is one of the
  /// few providers that's intentionally app-wide rather than scoped.
  ///
  /// Previously a hand-written `Provider<FailureMapper>(...)` — converted to
  /// codegen so every app-wide provider in Core follows the same declaration
  /// pattern as `connectivityProvider` / `dioProvider`, instead of mixing
  /// manual and generated providers for the same kind of job. See
  /// `core/logging/talker_provider.dart` for the one deliberate, documented
  /// exception to this convention.
  FailureMapperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'failureMapperProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$failureMapperHash();

  @$internal
  @override
  $ProviderElement<FailureMapper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FailureMapper create(Ref ref) {
    return failureMapper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FailureMapper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FailureMapper>(value),
    );
  }
}

String _$failureMapperHash() => r'4452dd8eda2e674f40bb96008dfd76a9b940347d';
