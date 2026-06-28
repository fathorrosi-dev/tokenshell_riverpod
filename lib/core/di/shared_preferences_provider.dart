import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

/// Provides an already-initialized [SharedPreferences] instance.
///
/// Declared at the DI layer so any provider that needs raw storage access
/// can depend on this single instance rather than calling getInstance()
/// in multiple places.
///
/// Override in tests with a mock or in-memory implementation.
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}
