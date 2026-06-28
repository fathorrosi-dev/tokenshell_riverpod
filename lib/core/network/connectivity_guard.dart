import 'package:fpdart/fpdart.dart';

import 'package:tokenshell_riverpod/core/errors/failure.dart';

/// A callable that performs a one-shot connectivity check, returning
/// `Left(NetworkFailure())` if no real internet connection is available,
/// or `Right(unit)` if the device can reach the backend.
///
/// Changed from `Future<void> Function()` (throw-based) to
/// `Future<Either<NetworkFailure, Unit>> Function()` (Either-based) in
/// R-05 (27 Jun 2026) to align with the established error propagation
/// contract used throughout the Data/Domain layers.
///
/// The previous throw-based design worked, but only because
/// [PostRepositoryImpl] happened to catch `on Exception` — which
/// intercepted the thrown [NetworkFailure] (a `Failure` that also
/// `implements Exception`) before re-mapping it. That implicit dependency
/// between throw type and catch clause was invisible to the compiler and
/// fragile: changing the catch clause to the more specific
/// `on DioException` (which a future developer might reasonably do)
/// would silently let [NetworkFailure] escape uncaught.
///
/// With the Either return type the contract is now explicit and
/// compiler-enforced: every call site must fold the result before
/// making a network request, and a missed fold is a type error, not a
/// runtime surprise.
///
/// Defined as a plain function type, not a class wrapping [Ref], so
/// Repository implementations stay decoupled from Riverpod entirely. The
/// actual wiring (`() => requiresConnectivity(ref)`) happens once in each
/// Repository's provider, not inside the Repository class itself.
///
/// Lives in Core/Network rather than inside a feature module — every
/// Repository that talks to a remote source needs the same connectivity
/// check, this isn't Posts-specific.
///
/// ## Ref-safety contract for implementors
///
/// Whatever closure you wire into this typedef will almost always close
/// over a provider's own [Ref] — e.g.
/// `connectivityGuard: () => requiresConnectivity(ref)` inside
/// `postRepositoryProvider` (`features/posts/di/posts_providers.dart`).
/// That captured [Ref] is only valid for as long as the provider that
/// captured it is alive. If the capturing provider is `autoDispose` (the
/// `@riverpod` default) and gets disposed between the closure being
/// created and being invoked, calling it throws "Cannot use a Ref after
/// it has been disposed."
///
/// **Rule: any provider that wires a closure into [ConnectivityGuard]
/// must be `keepAlive: true`.**
typedef ConnectivityGuard = Future<Either<NetworkFailure, Unit>> Function();
