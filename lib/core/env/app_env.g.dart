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
    3009029141,
    1044898731,
    1903863129,
    2368561070,
    3007524709,
    1826893709,
    1159289906,
    400075107,
    2112713502,
    1986000354,
    2745637609,
    302892902,
    1605617742,
    570279169,
    3760285199,
    1228289568,
    3309352603,
  ];

  static const List<int> _envieddataapiKey = <int>[
    3009029228,
    1044898756,
    1903863084,
    2368561116,
    3007524666,
    1826893804,
    1159289922,
    400075018,
    2112713537,
    1986000265,
    2745637516,
    302892831,
    1605617681,
    570279273,
    3760285290,
    1228289618,
    3309352702,
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
