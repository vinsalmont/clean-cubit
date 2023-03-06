import 'package:clean_cubit/presentation/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
          ),
        ),
        initialRoute: feed,
        onGenerateRoute: routeGeneration,
      );
}
