// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides an already-initialized [SharedPreferences] instance.
///
/// Declared at the DI layer so any provider that needs raw storage access
/// can depend on this single instance rather than calling getInstance()
/// in multiple places.
///
/// Override in tests with a mock or in-memory implementation.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Provides an already-initialized [SharedPreferences] instance.
///
/// Declared at the DI layer so any provider that needs raw storage access
/// can depend on this single instance rather than calling getInstance()
/// in multiple places.
///
/// Override in tests with a mock or in-memory implementation.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// Provides an already-initialized [SharedPreferences] instance.
  ///
  /// Declared at the DI layer so any provider that needs raw storage access
  /// can depend on this single instance rather than calling getInstance()
  /// in multiple places.
  ///
  /// Override in tests with a mock or in-memory implementation.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'50d46e3f8d9f32715d0f3efabdce724e4b2593b4';
