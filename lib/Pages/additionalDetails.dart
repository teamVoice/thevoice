import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thevoice2/Home/home.dart';
import 'package:thevoice2/MainPage.dart';
import 'package:thevoice2/SystemUiValues.dart';

class AdditionalDetails extends StatefulWidget {
  const AdditionalDetails({super.key, required this.isEdit});

  final bool isEdit;

  @override
  State<AdditionalDetails> createState() => _AdditionalDetailsState();
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _gender = TextEditingController();
  final _profession = TextEditingController();
  final _phone = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  Future uploadData(String docId) async {
    if (_name.text == "" ||
        _age.text == "" ||
        _gender.text == "" ||
        _profession.text == "" ||
        _phone.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Enter all the fields",
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
          backgroundColor: Colors.deepPurple.shade200,
          animation: AlwaysStoppedAnimation(2),
        ),
      );
    } else {
      Map<String, String> user = {
        "name": _name.text.trim(),
        "age": _age.text.trim(),
        "gender": _gender.text.trim(),
        "phone": _phone.text.trim(),
        "profession": _profession.text.trim(),
      };
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc("$docId")
            .set(user)
            .then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainPage()));
        });
      } on FirebaseException catch (e) {
        print(e.message);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${e.message}")));
      }
    }
  }

  Future updateData(String docId) async {
    if (_name.text == "" ||
        _age.text == "" ||
        _gender.text == "" ||
        _profession.text == "" ||
        _phone.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Enter all the fields",
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
          backgroundColor: Colors.deepPurple.shade200,
          animation: AlwaysStoppedAnimation(2),
        ),
      );
    } else {
      Map<String, String> user = {
        "name": _name.text.trim(),
        "age": _age.text.trim(),
        "gender": _gender.text.trim(),
        "phone": _phone.text.trim(),
        "profession": _profession.text.trim(),
      };
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc("$docId")
            .update(user);
      } on FirebaseException catch (e) {
        print(e.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${e.message}",
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
            backgroundColor: Colors.deepPurple.shade200,
            animation: AlwaysStoppedAnimation(2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SystemUi.systemColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                "Additional Details",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
              ),
            ),
            SliverToBoxAdapter(
              child: TextField(
                controller: _name,
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                    label: const Text("Enter your full name"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: TextField(
                controller: _age,
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                    label: const Text("Age"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: TextField(
                controller: _gender,
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                    label: const Text("Gender"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: TextField(
                controller: _profession,
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                    label: const Text("Profession"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: TextField(
                controller: _phone,
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                    label: const Text("Phone"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: widget.isEdit
                  ? CupertinoButton(
                      child: Text("Update Profile"),
                      onPressed: () async {
                        var uid = user!.uid;
                        updateData(uid);
                        Navigator.pop(context);
                      },
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      color: Colors.deepPurple,
                    )
                  : CupertinoButton(
                      child: Text(
                        "Save",
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        var uid = user!.uid;
                        await uploadData(uid);
                      },
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      color: Colors.deepPurple,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
