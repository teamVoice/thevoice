import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thevoice2/Authentication/login.dart';
import 'package:thevoice2/Authentication/signup.dart';
import 'package:thevoice2/Models/activityData.dart';
import 'package:thevoice2/Models/activityModel.dart';
import 'package:thevoice2/Models/profileImageViewer.dart';
import 'package:thevoice2/Pages/additionalDetails.dart';
import 'package:thevoice2/SystemUiValues.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;
  final picker = ImagePicker();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
  String profession = "Profession";
  String age = "Age";
  String userName = "UserName";
  String? profileImage;
  String? emailAddress = FirebaseAuth.instance.currentUser!.email;
  List<Object> _activityList = [
    ActivityData(
        "https://www.flaticon.com/free-icon/work-time_2255211?term=activities&page=1&position=15&origin=search&related_id=2255211",
        "Start Contributing to the society")
  ];

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
    await setProfileImage();
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future setProfileImage() async {
    String? url;
    try {
      Reference imageFolder = await FirebaseStorage.instance
          .ref("images/profileImages")
          .child(currentUserId);

      await imageFolder.putFile(_image!);
      await imageFolder.getDownloadURL().then((value) => url = value);

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId)
          .update({"profileImage": url}).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SystemUi.NormalSnackBar(
            title: "Profile image is set successfully"));
      });
    } on FirebaseException catch (e) {
      print(e);
    }
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

  Future getUserData() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserId)
        .get()
        .then((value) {
      Map<String, dynamic> map = value.data() as Map<String, dynamic>;
      setState(() {
        userName = map['name'];
        profession = map['profession'];
        age = map['age'];
        profileImage = map['profileImage'];
      });
    });
    if (kDebugMode) {
      print(currentUserId);
      print(profileImage);
    }
  }

  Future getUserActivities() async {
    final activityQuerySnapshot = await FirebaseFirestore.instance
        .collection("UserActivities")
        .doc(currentUserId)
        .collection("ActivityList")
        .get();

    if (kDebugMode) {
      print(activityQuerySnapshot.docs.length);
    }

    if (mounted) {
      setState(() {
        _activityList = List.from(activityQuerySnapshot.docs
            .map((doc) => ActivityData.fromSnapshot(doc)));
        if (kDebugMode) {
          print(_activityList.length);
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    getUserActivities();
  }

  @override
  Widget build(BuildContext context) {
    print(_activityList.length);
    print(profileImage);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: Colors.deepPurple,
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileImageView(
                      imagePath: profileImage, showOptionsCallback: showOption),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      userName,
                      style: SystemUi.headerTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email : $emailAddress",
                  style: SystemUi.profilePageSTextStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Profession: $profession",
                  style: SystemUi.profilePageSTextStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Age: $age",
                  style: SystemUi.profilePageSTextStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Recent Activities : ",
                  style: SystemUi.profilePageSTextStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 210,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _activityList.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ActivityModel(
                        activity: _activityList[index] as ActivityData,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: CupertinoButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AdditionalDetails(isEdit: true)));
            },
            child: Text("Edit Profile"),
          ),
        ),
      ],
    );
  }
}
