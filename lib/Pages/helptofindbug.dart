import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thevoice2/SystemUiValues.dart';

class HeplToBug extends StatefulWidget {
  const HeplToBug({super.key});

  @override
  State<HeplToBug> createState() => _HeplToBugState();
}

class _HeplToBugState extends State<HeplToBug> {
  final _controller = TextEditingController();

  Future submit() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SystemUi.NormalSnackBar(title: "Write something about bug."));
    } else {
      try {
        final ref = await FirebaseFirestore.instance.collection('Bugs');
        await ref.add({"description": _controller.text.trim()}).then((value) {
          _controller.clear();
          ScaffoldMessenger.of(context).showSnackBar(
              SystemUi.NormalSnackBar(title: "Thank you for your feedback"));
        });
      } on FirebaseException catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: SystemUi.systemColor,
        appBar: AppBar(
          title: Text(
            "Help to find bug",
            style: GoogleFonts.roboto(fontSize: 24, color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      fillColor: Colors.deepPurple.shade50,
                      filled: true,
                      hintText: "Write about bug",
                      hintMaxLines: 5,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(10),
                    onPressed: submit                                                  ,
                    child: Text("Submit"),
                    color: Colors.red,
                  ),
                ),
                Image(
                  image: AssetImage("images/bugImage.jpg"),
                  color: SystemUi.systemColor,
                  colorBlendMode: BlendMode.multiply,
                )
              ],
            ),
          ),
        ));
  }
}
