import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:thevoice2/Models/messageData.dart';
import 'package:thevoice2/Models/messageModel.dart';
import 'package:thevoice2/SystemUiValues.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final _controller = TextEditingController();
  final picker = ImagePicker();

  List<MessageData> feed = [];

  File? _image;

  String? asseturl;

  AssetImage _placeholderImage = const AssetImage("images/commPlace.jpg");

  final currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
  String? emailAddress = FirebaseAuth.instance.currentUser!.email;
  String? userName;
  String? profileImage;

  Future getAsset() async {
    String imageUrl = "";
    String uid = Uuid().v4();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    Reference imageFile = await FirebaseStorage.instance.ref("Feed").child(uid);

    if (pickedImage != null) {
      _image = File(pickedImage.path);
    }

    try {
      await imageFile.putFile(_image!);
      await imageFile.getDownloadURL().then((value) => asseturl = value);
    } on FirebaseStorage catch (e) {
      print(e);
    }
  }

  Future getFeed() async {
    try {
      await FirebaseFirestore.instance
          .collection("Community")
          .get()
          .then((value) {
        List<MessageData> temp = [];
        temp = List.from(value.docs.map((doc) => MessageData.jsonFrom(doc)));
        setState(() {
          feed = temp;
        });
      });
    } on FirebaseFirestore catch (e) {
      print(e);
    }
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
        profileImage = map['profileImage'];
      });
    });
    if (kDebugMode) {
      print(currentUserId);
    }
  }

  Future _post() async {
    if (_controller.text == "") {
      SystemUi.NormalSnackBar(title: "Write something!");
    }
    else {
      String uid = DateTime.now().toString();
      await FirebaseFirestore.instance
          .collection("Community").doc(uid)
          .set({
        "id": uid,
        "imageUrl": asseturl,
        "likes": 0,
        "message": _controller.text.trim(),
        "shares": 0,
        "time": DateTime.now(),
        "userImage": profileImage,
        "userName": userName
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
            SystemUi.NormalSnackBar(
                title: "Uploaded successfully!"));
        _controller.clear();

        setState(() {
          getFeed();
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    getFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SystemUi.systemColor,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Connect to Community",
          style: GoogleFonts.roboto(fontSize: 24, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        feed.length == 0? Image(image: _placeholderImage , color: SystemUi.systemColor, colorBlendMode: BlendMode.multiply,) :
                        ListView.builder(
                          padding: EdgeInsets.all(4),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            MessageData data = feed[index];
                            return MessageModel(
                              message: data.message,
                              userName: data.userName,
                              userImage: data.userImage,
                              imageUrl: data.imageUrl,
                              likes: data.likes,
                              shares: data.shares,
                              id: data.id,
                            );
                          },
                          itemCount: feed.length,
                          shrinkWrap: true,
                        )
                      ],
                    ),
                  ),
                )),
            Container(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(LineIcons.photoVideo),
                      onPressed: getAsset,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _post,
                    ),
                    hintText: "Write something...",
                    hintStyle:
                    GoogleFonts.roboto(fontSize: 14, color: Colors.black),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
