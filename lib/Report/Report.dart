import 'dart:convert';
import 'dart:io';
import 'package:emailjs/emailjs.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:thevoice2/Services/LocationServices/locationService.dart';
import 'package:thevoice2/SystemUiValues.dart';
import 'package:uuid/uuid.dart';

class ReportIncident extends StatefulWidget {
  const ReportIncident({super.key});

  @override
  State<ReportIncident> createState() => _ReportIncidentState();
}

class _ReportIncidentState extends State<ReportIncident> {
  var imagePath = const AssetImage("images/reportpage.jpg");
  final TextEditingController _controller = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  final currentUserId = FirebaseAuth.instance.currentUser?.uid.toString();
  double _progress = 0;
  LocationService locationService = LocationService();
  late String userName;
  late String emailAddress;
  double? altitude;
  double? latitude;
  double? accuracy;

  Future getUserData() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserId)
        .get()
        .then((value) {
      Map<String, dynamic> map = value.data() as Map<String, dynamic>;
      setState(() {
        userName = map['name'];
        emailAddress = FirebaseAuth.instance.currentUser!.email!;
      });
    });
    if (kDebugMode) {
      print(currentUserId);
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(
      () {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      },
    );
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(
      () {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      },
    );
  }

  Future showOption() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                getImageFromGallery();
              },
              child: const Text("Gallery")),
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                getImageFromCamera();
              },
              child: const Text("Camera"))
        ],
      ),
    );
  }

  // void _sendEmail() async {
  //   try {
  //     await EmailJS.send(
  //       'service_isp12zl',
  //       'template_m88z0le>',
  //       {
  //         'user_email': "dhagegopal305@gmail.com",
  //         'message': 'Hi',
  //       },
  //       const Options(
  //         publicKey: 'p2Mir1OD24Byhg_op',
  //         privateKey: 'PxdYRlryTdy0L-es3gn-9',
  //       ),
  //     );
  //     print('SUCCESS!');
  //   } catch (error) {
  //     if (error is EmailJSResponseStatus) {
  //       print('ERROR... ${error.status}: ${error.text}');
  //     }
  //     print(error.toString());
  //   }
  // }

  Future sendFeedback() async {
    var template_id = "template_ggt4pgf";
    var service_id = "service_isp12zl";
    var user_id = "p2Mir1OD24Byhg_op";

    var url = Uri.parse(" https://api.emailjs.com/api/v1.0/email/send");

    var response = await http.post(url,
        headers: {
          "origin": "http://localhost",
          "Content-Type": "application/json"
        },
        body: json.encode({
          "template_id": template_id,
          "service_id": service_id,
          "user_id": user_id,
          "template_params": {
            "to_name": userName,
            "to_user": FirebaseAuth.instance.currentUser!.email,
          }
        }));

    print("This is the response from the email serivice + ${response.body}");
  }

  Future _post() async {
    if (_controller.text.trim() != "") {
      try {
        print(_image!.path);
        String unique = DateTime.now().microsecondsSinceEpoch.toString();
        final storageReference =
            FirebaseStorage.instance.ref().child("images/issues");
        Reference imagesFolder = storageReference.child(unique);

        await imagesFolder.putFile(File(_image!.path));

        String imageUrl = await imagesFolder.getDownloadURL();

        var issueId = Uuid().v8obj();
        await FirebaseFirestore.instance.collection("Issues").add({
          "issueId" : issueId.toString(),
          "imageUrl": imageUrl,
          "description": _controller.value.text.trim(),
          "location" : {
            "altitude" :altitude.toString(),
            "latitude" :latitude.toString(),
            "accuracy" :accuracy.toString(),
          }
        });
        var uuid = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection("UserActivities")
            .doc(currentUserId)
            .collection("ActivityList")
            .doc(uuid)
            .set({
          "imageUrl": imageUrl,
          "description": _controller.value.text.trim()
        });

        setState(() {
          _image = null;
          _controller.clear();
          _progress = 0.0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Thank you for your contribution!!",
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
            backgroundColor: Colors.deepPurple.shade200,
            animation: AlwaysStoppedAnimation(2),
          ),
        );

        sendFeedback();

        print(imageUrl);
      } on FirebaseFirestore catch (e) {
        if (kDebugMode) {
          print("this is the error $e");
        }
        ScaffoldMessenger.of(BuildContext as BuildContext).showSnackBar(
          const SnackBar(
              content: Text("Couldn't upload the data, Please try again!"),
              backgroundColor: Colors.black),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter some details")));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: [
        SliverAppBar(
          expandedHeight: 50,
          backgroundColor: Colors.deepPurple.shade100,
          pinned: true,
          title: Text(
            "Report Incident",
            style: SystemUi.headerTextStyle,
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Colors.deepPurple,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _image == null
                      ? Image(
                          image: imagePath,
                          height: 280,
                          width: 280,
                    colorBlendMode: BlendMode.multiply,
                    color: SystemUi.systemColor,
                        )
                      : Image.file(
                          File(_image!.path),
                          width: 200,
                          height: 400,
                        ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurple,
                        child: Text("Choose Photo"),
                        onPressed: () {
                          showOption();
                        }),
                    CupertinoButton(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurple,
                        child: Text("Add Location"),
                        onPressed: () {
                          locationService.requestPermission();
                          locationService.getCurrentLocation().then((value) {
                            print(value.altitude);
                            print(value.latitude);
                            print(value.accuracy);
                            print(value.provider);
                            setState(() {
                              altitude = value.altitude;
                              latitude = value.altitude;
                              accuracy = value.accuracy;
                            });
                          });

                          ScaffoldMessenger.of(context).showSnackBar(SystemUi.NormalSnackBar(title: "Location has been added!"));

                        }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    style: GoogleFonts.roboto(
                        fontSize: 14, fontWeight: FontWeight.normal),
                    autocorrect: true,
                    controller: _controller,
                    decoration: InputDecoration(
                      label: const Text(
                        "Write the description",
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                Center(
                  child: CupertinoButton(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple,
                      child: Text("Report Issue"),
                      onPressed: () {
                        _post();
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Center(
                //   child: SizedBox(
                //     height: 200,
                //     width: 200,
                //     child: Padding(
                //       padding: const EdgeInsets.all(5.0),
                //       child: LiquidCircularProgressIndicator(
                //         value: _progress / 100,
                //         valueColor:
                //         const AlwaysStoppedAnimation(Colors.deepPurple),
                //         backgroundColor: Colors.deepPurple.shade100,
                //         center: Text("$_progress%",
                //             style: GoogleFonts.roboto(
                //                 color: Colors.black, fontSize: 18)),
                //         direction: Axis.vertical,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
