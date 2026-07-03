// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: .env
final class _AppEnv {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static const List<int> _enviedkeyapiKey = <int>[
    109108644,
    3801266038,
    3139999361,
    2799428437,
    3330689000,
    2727488065,
    3347861919,
    3834040663,
    2955760701,
    3618232018,
    1834738810,
    459680503,
    2042082940,
    478857207,
    334997003,
    3485165965,
    2136106601,
  ];

  static const List<int> _envieddataapiKey = <int>[
    109108701,
    3801265945,
    3139999476,
    2799428391,
    3330688951,
    2727488032,
    3347861999,
    3834040638,
    2955760738,
    3618231993,
    1834738719,
    459680398,
    2042082851,
    478857119,
    334997102,
    3485166079,
    2136106508,
  ];

  static final String apiKey = String.fromCharCodes(
    List<int>.generate(
      _envieddataapiKey.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddataapiKey[i] ^ _enviedkeyapiKey[i]),
  );

  static const String sentryDsn =
      'https://ca4681f0a60ef89faed630f5e738f746@o4511625171501056.ingest.de.sentry.io/4511625188737104';
}
