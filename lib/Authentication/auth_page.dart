import 'package:flutter/cupertino.dart';
import 'package:thevoice2/Authentication/signup.dart';
import 'login.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool showLoginPage = true;

  void toggleScreen(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage();
    }else{
      return SignUp();
    }
  }
}
