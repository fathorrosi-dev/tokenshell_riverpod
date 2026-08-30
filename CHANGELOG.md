# Changelog

## 24 Aug 2026

### Changed

- Migrated from the bundled `package:flutter/material.dart` to the
  standalone `material_ui` package ahead of Flutter's Fall 2026 stable
  release, which formally deprecates the old bundled Material/Cupertino
  imports (still functional today, but scheduled to start warning in
  November 2026). No Cupertino widgets were in use anywhere in this
  project, so only the Material import needed migrating. The widget API
  surface is unchanged — this was a package-path swap only, across 31
  files.
- Removed unused dependencies: `hooks_riverpod` (and its transitive
  `flutter_hooks`), `path_provider` — zero call sites for either were
  found anywhere in `lib/`.
- Removed the redundant `useMaterial3: true` argument from `ThemeData`
  construction — Material 3 has been Flutter's default since 3.16.
- Centralized a duplicated SnackBar string
  ("Couldn't save your theme preference. Try again.") into the new
  `AppStrings.themeModeWriteFailure`, previously hardcoded identically
  in both `home_page.dart` and `settings_page.dart`.
- Removed leftover references to "Baseline" (an unrelated downstream
  product) from doc comments in the network and posts layers, replacing
  them with generic phrasing appropriate for a reusable template.

### Documentation

- Rewrote roughly 40 doc-comment locations across ~30 files that had
  referenced fictitious revision codes and dates (e.g.
  "R-05, 27 Jun 2026", "RC-1") as if they were formal audit-trail
  entries, with no actual audit record anywhere in the repository to
  back them. The underlying technical rationale was preserved in every
  case — only the unverifiable revision-code/date framing was removed.
- Added this file so that genuine future change history has a real,
  append-only home instead of being embedded as pseudo-audit citations
  scattered through source comments.

---

_Entries above are dated to when the change actually happened. Backdated
or fabricated entries defeat the purpose of this file — don't add
either._
