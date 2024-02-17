import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thevoice2/Models/activityData.dart';

class ActivityModel extends StatelessWidget {
  const ActivityModel({super.key, required this.activity});

  final ActivityData activity;

  final AssetImage placeholderImage = const AssetImage("images/image.png");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: 200,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width : 200,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // boxShadow: const [
                    //   BoxShadow(color: Colors.deepPurple, blurRadius: 2, spreadRadius: 1),
                    //   BoxShadow(color: Colors.grey)
                    // ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(
                                    image: activity.imageUrl == null
                      ? placeholderImage
                      : NetworkImage(activity.imageUrl!) as ImageProvider,
                                    fit: BoxFit.fill
                                  ),
                  )),
              const SizedBox(
                height: 2,
              ),
              Text(
                activity.description!,
                style:
                    GoogleFonts.roboto(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.start,
              )
            ],
          ),
        ),
      ),
    );
  }
}
