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
    2302947641,
    2795590680,
    3765975069,
    3066433194,
    382634911,
    3872906984,
    3465568017,
    1497458063,
    1701399374,
    2461752706,
    922238440,
    2310116243,
    4206884447,
    281961325,
    4059799091,
    1286987668,
    3324447424,
  ];

  static const List<int> _envieddataapiKey = <int>[
    2302947648,
    2795590775,
    3765975144,
    3066433240,
    382634944,
    3872906889,
    3465568097,
    1497458150,
    1701399313,
    2461752809,
    922238349,
    2310116330,
    4206884352,
    281961221,
    4059799126,
    1286987750,
    3324447397,
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
