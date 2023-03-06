import 'dart:async';

import 'package:clean_cubit/app.dart';
import 'package:clean_cubit/dependency_injection/dependency_injector.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart' as log;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjector.registerDependencies();

  runZonedGuarded(() => runApp(const AppRoot()), (error, stackTrace) async {
    log.Logger(printer: log.PrettyPrinter(methodCount: 0)).i(
      '[runZonedGuarded] - Failed $error, StackTrace: $stackTrace',
    );
  });

  FlutterError.onError = (details) => Zone.current.handleUncaughtError(
        details.exception,
        details.stack ?? StackTrace.current,
      );
}
