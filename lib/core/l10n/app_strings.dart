/// Single indirection point for every user-facing string literal in this
/// app today.
///
/// ## What this is — and isn't — yet
///
/// This is **not** internationalization. There's still only one locale
/// (English), and every value below is a `static const String` (or a
/// `static String` method for values with interpolated data), not
/// something resolved per-[Locale] via `flutter_localizations` / ARB
/// files. What this *is*: a single seam between "where a string is used"
/// and "where its literal value is defined" — so the day a second
/// locale is actually needed, the retrofit becomes "replace this file's
/// constants with `AppLocalizations.of(context).xxx` calls in one place"
/// rather than "grep every widget under `features/` and `shared/` for
/// English copy and replace each call site individually."
///
/// Added ahead of any real localization need: every new feature this
/// template's consumers build adds more hardcoded copy, and the retrofit
/// above only gets more expensive the more call sites there are to find
/// and touch. Wrapping strings behind this now — while there are still
/// few enough to do it in one pass — costs nearly nothing today and is
/// meaningfully cheaper than the same exercise later.
///
/// ## What's deliberately NOT here
///
/// `home_page.dart`'s design-token preview (color swatch labels like
/// `'background'`, `'primary'`; typography row labels like
/// `'displayLarge'`, `'bodyMedium'`) is intentionally excluded. Those
/// strings identify actual design-system token/style names for a
/// developer-facing preview screen — translating "background" into
/// another language would misrepresent what it's labelling. Only
/// genuine user-facing copy belongs in this file.
///
/// ## Organization
///
/// Grouped by the feature/widget that owns each string, not
/// alphabetically — a string's section tells you where its call site
/// lives.
final class AppStrings {
  const AppStrings._(); // Static-only — never instantiate.

  // ── Shared / AppStateView (shared/widgets/app_state_view.dart) ─────────────
  static const String stateEmptyTitle = 'Nothing here yet';
  static const String stateErrorTitle = 'Something went wrong';
  static const String stateErrorActionLabel = 'Try again';

  // ── Shared / AppShell (shared/shell/app_shell.dart) ─────────────────────
  static const String shellOfflineBanner = 'No internet connection';

  // ── Shared / Nav destination labels (each feature's *_routes.dart) ─────
  static const String navHome = 'Home';
  static const String navSettings = 'Settings';
  static const String navPosts = 'Posts';

  // ── Core / Routing — not-found page (core/routing/app_router.dart) ─────
  static const String notFoundTitle = 'Page not found';
  static const String notFoundActionLabel = 'Go home';
  static String notFoundMessage(Uri uri) => '"$uri" doesn\'t exist.';

  // ── Home page (features/home/presentation/home_page.dart) ──────────────
  static const String homeAppBarTitle = 'Home';
  static const String homeToggleThemeTooltip = 'Toggle theme';
  static const String homeHeading = 'TokenShell Riverpod';
  static const String homeSubheading =
      'shadcn/ui design tokens · Clean Architecture · Riverpod';
  static const String homeColorTokensSectionTitle = 'Color Tokens';
  static const String homeTypographySectionTitle = 'Typography Scale';

  // ── Settings page (features/settings/presentation/settings_page.dart) ──
  static const String settingsAppBarTitle = 'Settings';
  static const String settingsAppearanceSectionTitle = 'Appearance';
  static const String settingsThemeModeLabel = 'Theme mode';
  static const String settingsThemeModeDescription =
      'Controls whether the app uses the light or dark colour scheme.';
  static const String settingsThemeModeSystem = 'System';
  static const String settingsThemeModeLight = 'Light';
  static const String settingsThemeModeDark = 'Dark';
  static const String settingsAboutSectionTitle = 'About';
  static const String settingsAboutTemplateLabel = 'Template';
  static const String settingsAboutTemplateValue = 'TokenShell Riverpod';
  static const String settingsAboutVersionLabel = 'Version';
  static const String settingsAboutVersionFallback = '—';
  static const String settingsAboutArchitectureLabel = 'Architecture';
  static const String settingsAboutArchitectureValue = 'Clean Architecture';
  static const String settingsAboutStateLabel = 'State';
  static const String settingsAboutStateValue = 'Riverpod';
  static const String settingsAboutDesignSystemLabel = 'Design system';
  static const String settingsAboutDesignSystemValue = 'shadcn/ui tokens';

  // ── Posts list page (features/posts/presentation/pages/posts_page.dart) ─
  static const String postsAppBarTitle = 'Posts';
  static const String postsRefreshTooltip = 'Refresh';
  static const String postsEmptyTitle = 'No posts found.';

  // ── Post detail page (.../pages/post_detail_page.dart) ──────────────────
  static String postDetailFallbackTitle(int postId) => 'Post #$postId';
  static String postDetailMeta(int userId, int postId) =>
      'User $userId · Post #$postId';

  // ── Post card (.../widgets/post_card.dart) ───────────────────────────────
  static String postCardIdBadge(int id) => '#$id';
  static String postCardUserBadge(int userId) => 'User $userId';
  static const String postCardReadMore = 'Read more';
}
