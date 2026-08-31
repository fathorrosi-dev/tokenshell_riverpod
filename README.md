# tokenshell_riverpod

A Material 3, production-hardened Flutter starter template — built to be a
reusable foundation for new apps, not a single-purpose project.

## Stack

- **State management:** Riverpod 3 (codegen syntax)
- **Routing:** go_router
- **Networking:** Dio + Retrofit
- **Modeling:** Freezed + json_serializable, with `fpdart`'s `Either` for
  explicit `Failure` propagation instead of thrown exceptions
- **Env config:** Envied (compile-time, not committed to source control)
- **Storage:** shared_preferences (non-sensitive) + flutter_secure_storage
  (tokens/credentials)
- **Observability:** Talker (logging) + Sentry (crash/error reporting)

## Getting started

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs`
3. Provide the required env values (see `lib/core/env/`)

## Project documentation

Architecture decisions, package rationale, and the pre-release checklist
live in [`lib/docs/`](lib/docs/) — start with `PACKAGE_DECISIONS.md`.
