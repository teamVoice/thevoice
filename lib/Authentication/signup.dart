import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thevoice2/Authentication/login.dart';
import 'package:thevoice2/Models/userDataModel.dart';
import 'package:thevoice2/Pages/email_varification.dart';
import 'package:thevoice2/SystemUiValues.dart';
import 'package:thevoice2/page_manager.dart';
import 'package:uuid/uuid.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassword = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  bool isValidEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  bool confirmPassword() {
    if (_passwordController.value.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Enter the fields", style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
          backgroundColor: Colors.deepPurple.shade200,
          animation: AlwaysStoppedAnimation(2),
        ),
      );
    }
    if (_passwordController.text.trim() == _confirmPassword.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future signUp() async {
    if (confirmPassword()) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.value.text.trim(),
                password: _passwordController.value.text.trim())
            .then((value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EmainVarification()));
        });
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("$e")));
          print("Error Occurred is : $e");
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Password didn't match"),
      )));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SystemUi.systemColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Center(
                      child: Image(
                    image: AssetImage("images/earth.png"),
                    height: 150,
                    width: 150,
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: Text(
                    "Register for TheVoice",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (input) =>
                        isValidEmail(input!) ? null : "Check your email",
                    controller: _emailController,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 14, fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.deepPurple.shade50,
                        label: const Text("Email"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _passwordController,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 14, fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.deepPurple.shade50,
                        label: const Text("create your password"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _confirmPassword,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 14, fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.deepPurple.shade50,
                        label: const Text("Confirm your password"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 5),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    onPressed: () {
                      signUp();
                    },
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                      },
                      child: Text(
                        "Registered Already? Login",
                        style: GoogleFonts.roboto(
                            fontSize: 16, fontWeight: FontWeight.bold, color : Colors.deepPurple),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
