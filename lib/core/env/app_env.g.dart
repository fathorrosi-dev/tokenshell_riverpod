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
    2466414527,
    3693374127,
    1567575429,
    240800061,
    714301714,
    3578478677,
    1547401057,
    2903856403,
    2778030871,
    4052815088,
    3883760702,
    2570721497,
    3966163254,
    716382984,
    4008620709,
    3176323906,
    457193874,
  ];

  static const List<int> _envieddataapiKey = <int>[
    2466414534,
    3693374144,
    1567575536,
    240800079,
    714301773,
    3578478644,
    1547400977,
    2903856506,
    2778030920,
    4052815003,
    3883760731,
    2570721440,
    3966163305,
    716383072,
    4008620736,
    3176323888,
    457193975,
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
