import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tokenshell_riverpod/core/di/theme_provider.dart';
import 'package:tokenshell_riverpod/core/routing/app_router.dart';

/// Root application widget.
///
// ignore: comment_references
/// Consumes [appRouterProvider] and [themeModeNotifierProvider] so that
/// routing and theming are fully driven by Riverpod state.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // Show a plain loading scaffold while the persisted theme loads.
    final themeAsync = ref.watch(themeModeProvider);
    final themeMode = themeAsync.when(
      data: (mode) => mode,
      loading: () => ThemeMode.system,
      error: (_, _) => ThemeMode.system,
    );

    return MaterialApp.router(
      title: 'TokenShell Riverpod',
      debugShowCheckedModeBanner: false,

      // Theme is produced entirely from design tokens — see AppTheme.
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      themeMode: themeMode,

      // Router
      routerConfig: router,
    );
  }
}
