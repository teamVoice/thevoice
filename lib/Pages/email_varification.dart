import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thevoice2/Home/home.dart';
import 'package:thevoice2/Pages/additionalDetails.dart';
import 'package:thevoice2/SystemUiValues.dart';

class EmainVarification extends StatefulWidget {
  const EmainVarification({super.key});

  @override
  State<EmainVarification> createState() => _EmainVarificationState();
}

class _EmainVarificationState extends State<EmainVarification> {
  bool isVerified = false;
  Timer? timer;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isVerified = user!.emailVerified;
    if (!isVerified) {
      sendVerificationMail();
    }

    timer =
        Timer.periodic(const Duration(seconds: 1), (_) => checkEmailVerified());
  }

  Future checkEmailVerified() async {
    await user?.reload().then((value){
      setState(() {
        isVerified = user!.emailVerified;
        if(isVerified) timer?.cancel();
      });
    });
  }

  Future sendVerificationMail() async {
    try {
      await user?.sendEmailVerification();
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.message}")));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SystemUi.systemColor,
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Verifying the user...",
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(
                height: 50,
              ),
              Text("Check your email",
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text("We have sent you an email on",
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text("${user?.email}"),
              SizedBox(
                height: 20,
              ),
              isVerified == true
                  ? SystemUi.NormalButton(
                  buttonName: "Next",
                  function: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const AdditionalDetails(isEdit: false),
                      ),
                    );
                  })
                  : SystemUi.NormalButton(
                buttonName: "Resend",
                function: () {
                  sendVerificationMail();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
