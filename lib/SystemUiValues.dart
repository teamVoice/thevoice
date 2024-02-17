import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SystemUi {
  static Color systemColor = Colors.deepPurple.shade100;

  static var profilePagePTextStyle = GoogleFonts.roboto(fontSize: 22);
  static var profilePageSTextStyle = GoogleFonts.roboto(fontSize: 18);
  static var headerTextStyle = GoogleFonts.roboto(
      fontSize: 26,
      color: Colors.white,
      letterSpacing: 1,
      fontWeight: FontWeight.bold);
  static var buttonStyle = GoogleFonts.roboto(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);

  static CupertinoButton NormalButton( { required String buttonName, required function}) {
    return CupertinoButton(
      onPressed: function,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Text(buttonName, style: buttonStyle,),
      ),
      color: Colors.deepPurple,
      borderRadius: BorderRadius.circular(15),
    );
  }

  static SnackBar NormalSnackBar({required String title}) {
    return SnackBar(
      content: Text(title, style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
      backgroundColor: Colors.deepPurple.shade200,
      animation: AlwaysStoppedAnimation(2),
      duration: Duration(seconds: 1),
    );
  }

}
