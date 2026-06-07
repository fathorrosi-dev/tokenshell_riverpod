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
    189164806,
    2255106219,
    3936781476,
    3306398735,
    2226051396,
    4067629391,
    2328414814,
    2519566241,
    2727365093,
    4236400384,
    454880310,
    437125959,
    3583248159,
    38494189,
    2543929424,
    1622456595,
    3039341429,
  ];

  static const List<int> _envieddataapiKey = <int>[
    189164927,
    2255106244,
    3936781521,
    3306398845,
    2226051355,
    4067629358,
    2328414766,
    2519566280,
    2727365050,
    4236400491,
    454880339,
    437125950,
    3583248192,
    38494085,
    2543929397,
    1622456673,
    3039341328,
  ];

  static final String apiKey = String.fromCharCodes(
    List<int>.generate(
      _envieddataapiKey.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddataapiKey[i] ^ _enviedkeyapiKey[i]),
  );
}
