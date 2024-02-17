import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class MessageModel extends StatefulWidget {
  const MessageModel(
      {super.key,
      required this.message,
      required this.userName,
      required this.userImage,
      required this.imageUrl,
      required this.likes,
      required this.shares,
      required this.id});

  final String? message;
  final String? userName;
  final String? userImage;
  final String? imageUrl;
  final int? likes;
  final int? shares;
  final String? id;

  @override
  State<MessageModel> createState() => _MessageModelState();
}

class _MessageModelState extends State<MessageModel> {

  bool isClicked = false;
  Future increaseLikes() async {
    await FirebaseFirestore.instance
        .collection("Community")
        .where("id", isEqualTo: widget.id);
  }

  Future likeButton() async{
    await FirebaseFirestore.instance.collection("Community").doc(widget.id).update({
      "likes" : "${widget.likes! + 1}"
    });
  }

  Future dislikeButton() async{
    await FirebaseFirestore.instance.collection("Community").doc(widget.id).update({
      "likes" : "${widget.likes! -1}"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Image(
                      image: widget.userImage == null
                          ? AssetImage("images/profile_user.png")
                              as ImageProvider
                          : NetworkImage(widget.userImage!),
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: Text(
                    widget.userName == null ? "UserName" : widget.userName!,
                    style: GoogleFonts.openSans(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 1,
                child: Container(
                  color: Colors.black,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: widget.imageUrl == "" ? SizedBox(height: 5,) : Image(
                      image: NetworkImage(widget.imageUrl!),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.message!,
                      style: GoogleFonts.openSans(fontSize: 16),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 1,
                child: Container(
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          if(isClicked){
                            likeButton();
                          }
                          setState(() {
                            isClicked = !isClicked;
                          });
                        },
                        icon: isClicked ? Icon(Icons.favorite, color: Colors.red,): Icon(Icons.favorite_outline)
                      ),
                      Text(widget.likes!.toString())
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            LineIcons.share,
                            size: 30,
                          )),
                      Text(widget.shares!.toString())
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
