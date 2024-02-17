import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thevoice2/SystemUiValues.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
     var message = ModalRoute
        .of(context)
        ?.settings
        .arguments;

    return Scaffold(
      backgroundColor: SystemUi.systemColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Notifications", style: GoogleFonts.roboto(color: Colors.white),),
            backgroundColor: Colors.deepPurple,
            expandedHeight: 50,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text("This is the sample notification."),
                    style: ListTileStyle.list,
                    dense: true,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 1, color: Colors.black)
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
