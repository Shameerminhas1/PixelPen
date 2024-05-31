import 'package:flutter/material.dart';
import 'package:pixelpen/Scan.dart';
import 'SplashScreen.dart';
import 'welcomescreen.dart';

void main() {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'splashscreen',
        routes: {
          'splashscreen': (context) => const SplashScreen(),
          'welcomescreen': (context) => WelcomeScreen(),
          'scan': (context) => const Scan(),
          'camera': (context) => const Scan(),
        },
        onGenerateRoute: (settings) {
          return null;
        }),
  );
}
