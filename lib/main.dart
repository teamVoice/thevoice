import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:thevoice2/FirebaseServices/Messaging/cloud_notification.dart';
import 'package:thevoice2/MainPage.dart';
import 'package:thevoice2/SystemUiValues.dart';

import 'Pages/notification.dart';

final navigatorkey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: "AIzaSyAkMidlwsClYcGHujdsrYrTriLsRluEE_s");
  await Hive.initFlutter();
  await Hive.openBox('History');
  await Hive.openBox('ActivityBox');
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAZUgG2pMv0IckxpF9e3fZ-RvMfsEkX-pc",
        appId: "1:375022318190:android:a6a18a3f69db5185c32c7f",
        messagingSenderId: "375022318190",
        projectId: "thevoice-1b756",
        storageBucket: "thevoice-1b756.appspot.com"),
  );


  await FirebaseMessagingService().initNotification();

  runApp(MaterialApp(
    home: Container(
      height: double.maxFinite,
      width: double.maxFinite,
      child: AnimatedSplashScreen(
        splashIconSize: double.maxFinite,
        centered: true,
        backgroundColor: SystemUi.systemColor,
        splash: Image(
          image: AssetImage("images/Opener Loading.gif"),
          fit: BoxFit.contain,
        ),
        nextScreen: const MainPage(),
        splashTransition: SplashTransition.scaleTransition,
        duration: 4900,
      ),
    ),
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(useMaterial3: true),
    navigatorKey: navigatorkey,
    routes: {'notification_screen': (context) => const NotificationPage()},
  ));
}
