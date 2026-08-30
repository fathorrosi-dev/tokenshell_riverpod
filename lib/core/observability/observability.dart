/// Barrel for the Observability subsystem.
///
/// Added because no crash reporter was integrated at all before this.
/// Exported as a whole from
/// `core/di/providers.dart`, same pattern as every other Core subsystem —
/// add new Observability files here, in this same folder, rather than
/// remembering to also touch the distant top-level barrel. See
/// `core/di/providers.dart`'s doc comment for the drift problem this
/// folder-local barrel exists to avoid.
library;

export 'sentry_bootstrap.dart';

// setSentryUser / clearSentryUser helpers for wiring
// user identity into Sentry scope on login / logout. Call sites live in
// the auth notifier once the login feature lands — see the file's doc
// comment for the full callsite contract.
export 'sentry_user_scope.dart';
