import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileImageView extends StatelessWidget {
   ProfileImageView({super.key, required this.imagePath, required this.showOptionsCallback});

  final AssetImage _profileImage = const AssetImage("images/earth.png");
  String? imagePath;
  VoidCallback showOptionsCallback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: CircleAvatar(
            backgroundImage: imagePath == null
                ? _profileImage
                : NetworkImage(imagePath!) as ImageProvider,
            backgroundColor: Colors.white,
            radius: 40,
          ),
        ),
        Positioned(
          top: 40,
          left: MediaQuery.of(context).size.width/2,
          child: IconButton(
            onPressed: showOptionsCallback,
            icon: const Icon(
              CupertinoIcons.add_circled,
              size: 26,
            ),
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
