import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thevoice2/Pages/email_varification.dart';
import 'Authentication/login.dart';
import 'page_manager.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Status bar color
    ));
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData && snapshot.data!.emailVerified){
            return const HomeScreen();
          }else if (snapshot.hasData && !snapshot.data!.emailVerified){
            return const EmainVarification();
          }else{
            return const LoginPage();
          }
        }
      )
    );
  }
}
