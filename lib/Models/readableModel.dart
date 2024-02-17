import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ReadableModel extends StatelessWidget {
  const ReadableModel({super.key, required this.title});
  final String? title;

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
                child: Image.asset(
                "images/image.png",
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
              Text(
                title!,
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
