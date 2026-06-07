import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:tokenshell_riverpod/app/app.dart';

/// Global Talker instance — shared across DI layers, router, and Dio.
final Talker talker = TalkerFlutter.init(
  settings: TalkerSettings(),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(
          talker: talker,
          settings: const TalkerRiverpodLoggerSettings(
            printStateFullData: false,
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
