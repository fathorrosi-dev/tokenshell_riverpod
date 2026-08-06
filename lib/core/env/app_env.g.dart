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
    915763629,
    148760886,
    1134297429,
    2705174443,
    1326094392,
    2111380993,
    1110502114,
    4223113744,
    372388480,
    2965757600,
    1963134091,
    1064922977,
    396231322,
    1348553056,
    2131542504,
    546305431,
    2758827965,
  ];

  static const List<int> _envieddataapiKey = <int>[
    915763668,
    148760921,
    1134297376,
    2705174489,
    1326094439,
    2111381088,
    1110502034,
    4223113849,
    372388575,
    2965757643,
    1963134190,
    1064922904,
    396231365,
    1348552968,
    2131542413,
    546305509,
    2758827992,
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
