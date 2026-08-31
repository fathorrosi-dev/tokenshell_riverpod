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
    3779749549,
    1838292525,
    3664884187,
    932619903,
    2546873452,
    280091402,
    573970638,
    3242198147,
    169216919,
    3827250084,
    2930705220,
    82454646,
    661592715,
    3048132378,
    3396248813,
    3808814491,
    2162266386,
  ];

  static const List<int> _envieddataapiKey = <int>[
    3779749588,
    1838292546,
    3664884142,
    932619789,
    2546873395,
    280091499,
    573970622,
    3242198250,
    169216968,
    3827250127,
    2930705185,
    82454543,
    661592788,
    3048132466,
    3396248712,
    3808814569,
    2162266487,
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
