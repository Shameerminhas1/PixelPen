import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'welcomescreen.dart';

void main() {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'splashscreen',
        routes: {
          'splashscreen': (context) => const SplashScreen(),
          'welcomescreen': (context) => WelcomeScreen()
        },
        onGenerateRoute: (settings) {
          return null;
        }),
  );
}
