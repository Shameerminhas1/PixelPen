import 'dart:ffi';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pixelpen/Camerainput.dart';
import 'package:pixelpen/Chat_screen.dart';
import 'package:pixelpen/Imagepanel.dart';
import 'package:pixelpen/Readaloud.dart';
import 'package:pixelpen/translate.dart';
import 'SplashScreen.dart';
import 'welcomescreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final cameras = await availableCameras();
  //final firstCamera = cameras.first;

  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'splashscreen',
        routes: {
          'splashscreen': (context) => const SplashScreen(),
          'welcomescreen': (context) => WelcomeScreen(),
          'camerainput': (context) => CameraInput(),
          'readaloud': (context) => ReadAloud(),
          'translate': (context) => TranslateScreen(),
          'chat_Screen': (context) => ChatScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == 'imagepanel') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => ImagePanel(
                imagePath: args['imagePath'],
                imagePaths: args['imagePaths'],
              ),
            );
          }
          return null;
        }),
  );
}
