import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thevoice2/Models/VideoData.dart';

class VideoModel extends StatelessWidget {
  const VideoModel({super.key, required this.videoSample});

  final VideoData videoSample;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        // height: MediaQuery.of(context).size.height/2,
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  videoSample.thumbnail,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
              Text(
                videoSample.title,
                style: GoogleFonts.roboto(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
