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
    1970088525,
    2468959081,
    1454767421,
    307827388,
    2380221026,
    966346474,
    191420193,
    2396471929,
    2996848000,
    3065303683,
    3967422166,
    4177115266,
    2542072624,
    808057205,
    426057910,
    1897192396,
    3274991527,
  ];

  static const List<int> _envieddataapiKey = <int>[
    1970088500,
    2468958982,
    1454767432,
    307827406,
    2380220989,
    966346379,
    191420241,
    2396471824,
    2996848095,
    3065303784,
    3967422131,
    4177115387,
    2542072687,
    808057117,
    426057939,
    1897192382,
    3274991554,
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
