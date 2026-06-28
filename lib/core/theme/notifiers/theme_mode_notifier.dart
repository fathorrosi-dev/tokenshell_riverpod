import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:tokenshell_riverpod/core/logging/talker_provider.dart';
import 'package:tokenshell_riverpod/core/theme/presentation/app_theme_mode_extensions.dart';
import 'package:tokenshell_riverpod/core/theme/providers/theme_repository_provider.dart';

part 'theme_mode_notifier.g.dart';

/// Backing notifier for [themeModeWriteFailureProvider] below. Trivial by
/// design — no async dependencies, no real lifecycle, just a settable slot.
class _ThemeModeWriteFailureNotifier extends Notifier<Object?> {
  @override
  Object? build() => null;

  /// The current failure value, if any.
  ///
  /// Mirrors [state] under a more descriptive name — [state] itself can
  /// only be read/written from *within* a [Notifier] subclass in
  /// Riverpod 3.x (enforced by riverpod_lint), so this getter/setter pair
  /// is the sanctioned way for outside code to reach it. Was a single
  /// `void set(Object? value)` method, but that just reassigned a
  /// property under a method name — `use_setters_to_change_properties`
  /// flagged it, and a lone setter with no matching getter is its own
  /// code smell, hence both here together.
  Object? get failure => state;

  set failure(Object? value) => state = value;
}

/// Most recent theme-mode *persistence* failure, so pages can react to it
/// (e.g. a one-shot SnackBar) without depending on [ThemeModeNotifier]'s
/// internals. `null` means "no pending failure to show".
///
/// Deliberately a separate provider rather than folded into
/// [ThemeModeNotifier]'s own `AsyncValue<ThemeMode>` — that state already
/// means "the current theme mode"; overloading it with "...or an error
/// that happened while saving a *previous* change" would make every
/// `.when()` call site on [themeModeProvider] responsible for telling
/// those two situations apart. Before this, [setThemeMode] silently
/// rolled the UI back to the previous value on a write failure with no
/// signal anywhere for the page to show *why* — Talker logged it, but the
/// user just saw their toggle snap back unexplained.
///
/// Manually-constructed [NotifierProvider] — NOT `@riverpod` codegen (a
/// transient UI signal with no async dependency doesn't need a generated
/// class), and NOT `StateProvider` (removed in Riverpod 3.x; `Notifier`
/// is the supported replacement, [legacy provider migration guide][1]).
/// Set a value from outside via `.notifier.failure = value` (and read it
/// back via `.notifier.failure`) — riverpod_lint forbids touching
/// `.notifier.state` directly outside the [Notifier] subclass itself, so
/// [_ThemeModeWriteFailureNotifier.failure] exists specifically as that
/// sanctioned entry point. Consumers should set `.failure = null` after
/// showing a failure, so the same one isn't re-shown on the next rebuild
/// — see `home_page.dart` / `settings_page.dart`.
///
/// [1]: https://riverpod.dev/docs/migration/from_state_notifier
final themeModeWriteFailureProvider =
    NotifierProvider<_ThemeModeWriteFailureNotifier, Object?>(
  _ThemeModeWriteFailureNotifier.new,
);

/// Async notifier that loads the persisted [ThemeMode] on first build,
/// exposes it to the widget tree, and persists changes via
/// [IThemeModeRepository].
///
/// State lifecycle:
///   - loading → while dependencies are initialising.
///   - data    → the resolved theme mode.
///   - error   → if repository construction fails.
///
/// Read failures are intentionally degraded to [ThemeMode.system]
/// so theme persistence issues never block application startup.
///
/// This Notifier is the conversion boundary between the pure-Dart
/// `AppThemeMode` (Domain/Data) and Flutter's [ThemeMode] (Presentation) —
/// the public API here stays [ThemeMode] so existing widget call sites
/// don't change; only the repository call underneath converts.
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  Future<ThemeMode> build() async {
    final repository = await ref.watch(themeModeRepositoryProvider.future);

    return repository.read().fold(
      (_) => ThemeMode.system,
      (mode) => mode.toFlutterThemeMode(),
    );
  }

  /// Applies [mode] immediately and persists it.
  ///
  /// Uses an optimistic update so the UI updates instantly.
  /// If persistence fails, the previous value is restored and the failure
  /// is published to [themeModeWriteFailureProvider] so the UI can tell
  /// the user their preference didn't actually save.
  ///
  /// Safe to call at any point in the notifier lifecycle — resolves the
  /// repository via [themeModeRepositoryProvider] instead of relying on a
  /// `late` field, eliminating [LateInitializationError] when called during
  /// [AsyncLoading] state on low-end devices with slow SharedPreferences init.
  Future<void> setThemeMode(ThemeMode mode) async {
    final previous = state.asData?.value ?? ThemeMode.system;

    state = AsyncData(mode);

    // Re-read the repository each time — the provider is keepAlive so this
    // resolves immediately after the first build completes.
    final repository = await ref.read(themeModeRepositoryProvider.future);
    final result = await repository.write(mode.toAppThemeMode());

    result.fold(
      (failure) {
        state = AsyncData(previous);
        // Log at warning level with operation context that the Sentry
        // breadcrumb below (success path only) and the repository's own
        // catch-block log don't carry: WHAT mode was being saved and WHAT
        // state is being rolled back to. The repository already logs the
        // raw exception or false-return detail; this log adds the Notifier's
        // perspective — useful when correlating a user's "toggled twice fast"
        // report with which of the two writes is the one that actually failed.
        ref.read(talkerProvider).warning(
          'ThemeModeNotifier: write failed — '
          'attempted "${mode.name}", rolling back to "${previous.name}". '
          'See ThemeModeRepository log for the low-level cause.',
        );
        ref.read(themeModeWriteFailureProvider.notifier).failure = failure;
      },
      (_) {
        // Record a breadcrumb so Sentry issue reports surface the active theme
        // mode at the time of any crash — especially valuable for dark-mode
        // visual bugs that are hard to reproduce without knowing the user's state.
        unawaited(Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'Theme mode changed',
            category: 'ui.theme',
            level: SentryLevel.info,
            data: {'mode': mode.name},
          ),
        ));
      },
    );
  }

  /// Cycles through:
  ///
  /// system → light → dark → system
  Future<void> toggle() async {
    final current = state.asData?.value ?? ThemeMode.system;

    final next = switch (current) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };

    await setThemeMode(next);
  }
}
