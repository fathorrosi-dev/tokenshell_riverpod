/// Barrel for the Storage subsystem.
///
/// Exported as a whole from `core/di/providers.dart` — add new Storage
/// provider/type files here, in the same folder you're already editing,
/// rather than remembering to also touch the distant top-level barrel.
/// See `core/di/providers.dart`'s doc comment for the drift problem this
/// folder-local barrel exists to avoid.
library;

// secureStorageProvider and secureStorageDatasourceProvider are generated
// by riverpod_generator. Export the datasource interface alongside so
// feature-level code can type-annotate against ISecureStorageDatasource
// without a separate import.
export 'i_secure_storage_datasource.dart';
export 'secure_storage_datasource.dart';
export 'secure_storage_provider.dart';
