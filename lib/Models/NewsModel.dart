import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsModel extends StatelessWidget {
  const NewsModel(
      {super.key,
      required this.title,
      required this.summary,
      required this.link});

  final String? title;
  final String? summary;
  final String? link;

  final AssetImage placeholderImage = const AssetImage("images/spinner.gif");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
            color: Theme.of(context).focusColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            // gradient: const LinearGradient(
            //     colors: [Colors.black12, Colors.transparent],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight)
         ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               title == null ? "Headline"  : title!,
                style: GoogleFonts.roboto(fontSize : 26, color:Colors.black),
              ),
              // placeholder for the headline
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Image(
                    fit: BoxFit.fill,
                    image: link == null? placeholderImage :  NetworkImage(link!) as ImageProvider,
                    width: MediaQuery.of(context).size.width,
                  )),
              // placeholder for the description
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: summary == null ? const Text("Loading...", textAlign: TextAlign.center,) : Text(summary!, style: GoogleFonts.roboto(fontSize : 18, fontStyle : FontStyle.italic),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
