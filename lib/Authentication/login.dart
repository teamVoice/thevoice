import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thevoice2/Authentication/signup.dart';
import 'package:thevoice2/SystemUiValues.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future login() async {
    if (_emailController.value.text.isEmpty ||
        _passwordController.value.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enter the fields"),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 1),
      ));
    } else {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: _emailController.value.text.trim(),
            password: _passwordController.value.text.trim());
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print("Error occurred is ${e.message}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("user not found")));
        }
      }
    }
  }

  @override
  void dispose(){
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SystemUi.systemColor,
        body: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 50,),
              const Center(
                child: Image(
                  image: AssetImage("images/earth.png"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _emailController,
                style: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                    hintText: "Email",
                    label: const Text("Email"),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueGrey)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey))),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _passwordController,
                style: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    hintText: "Password",
                    label: const Text("Password"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueGrey)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey))),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoButton(
                color: Colors.deepPurple,
                onPressed: login,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  child: Text(
                    "Log In",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child:  Text("Have you registered? Register", style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
