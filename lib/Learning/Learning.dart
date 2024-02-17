import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thevoice2/Models/VideoData.dart';
import 'package:thevoice2/Models/pdfModel.dart';
import 'package:thevoice2/Models/readableData.dart';
import 'package:thevoice2/Players/videoplayer.dart';
import 'package:thevoice2/SystemUiValues.dart';
import 'package:thevoice2/main.dart';

import '../Models/readableModel.dart';
import '../Models/videoModel.dart';
import '../Pages/pedfviewerpage.dart';

class LearingPlace extends StatefulWidget {
  const LearingPlace({super.key});

  @override
  State<LearingPlace> createState() => _LearingPlaceState();
}

class _LearingPlaceState extends State<LearingPlace> {
  List<VideoData> _trendingTopics = [
    VideoData(
        title: ("This United Nations Initiative With Google"),
        videoUrl: "https://www.shutterstock.com/shutterstock/videos/1104713067/preview/stock-footage-icon-set-the-global-goals-corporate-social-responsibility-sustainable-development-goals-k.webm",
        thumbnail:
        "https://1millionstartups.com/datoteke/slike/2020/2020-04-20/post_img_Weekly_SDGs_2020_16.jpg"),
  ];

  List<VideoData> _primaryEducation = [
    VideoData(
        title: ("This United Nations Initiative With Google"),
        videoUrl: "https://www.shutterstock.com/shutterstock/videos/1098968423/preview/stock-footage-environmental-technology-concept-sustainable-development-goals-sdgs.webm",
        thumbnail:
        "https://1millionstartups.com/datoteke/slike/2020/2020-04-20/post_img_Weekly_SDGs_2020_16.jpg"),
  ];

  List<VideoData> _secondaryEducation = [
    VideoData(
        title: ("This United Nations Initiative With Google"),
        videoUrl: "https://www.shutterstock.com/shutterstock/videos/1104715009/preview/stock-footage-icon-set-the-global-goals-corporate-social-responsibility-sustainable-development-goals-k.webm",
        thumbnail:
        "https://1millionstartups.com/datoteke/slike/2020/2020-04-20/post_img_Weekly_SDGs_2020_16.jpg"),
  ];

  List<PdfModel> _readableResources = [
    PdfModel(title: "This is United Nations"),
  ];


  Future<File> storeFile(String url, List<int> bytes) async{
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${filename}');
    await file.writeAsBytes(bytes);
    return file;
  }


  // methods to fetch the videos from database for different categories 

  Future getTrendingTopics() async {
    try {
      var trendingVideoRef = await FirebaseFirestore.instance.collection(
          "Trending").get();
      setState(() {
        _trendingTopics = List.from(trendingVideoRef.docs.map((doc) {
          return VideoData.fromList(doc);
        },),);
      },);
    } on Error catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
          content: Text("Unable to load videos check hour connection")));
    }
  }

  Future getPrimaryEducation() async {
    try {
      var primaryEducationRef = await FirebaseFirestore.instance.collection(
          "Primary Education").get();
      setState(() {
        _primaryEducation = List.from(primaryEducationRef.docs.map((doc) {
          return VideoData.fromList(doc);
        },),);
      },);
    } on Error catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
          content: Text("Unable to load videos check hour connection")));
    }
  }

  Future getSecondaryEducation() async {
    try {
      var secondaryEducationRef = await FirebaseFirestore.instance.collection(
          "Secondary Education").get();
      setState(() {
        _secondaryEducation = List.from(secondaryEducationRef.docs.map((doc) {
          return VideoData.fromList(doc);
        },),);
      },);
    } on Error catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
          content: Text("Unable to load videos check hour connection")));
    }
  }

  Future getReadableResources() async {
    try {
      var readableResourcesRef = await FirebaseFirestore.instance.collection(
          "Pdf Resources").get();
      setState(() {
        _readableResources = List.from(readableResourcesRef.docs.map((doc) {
          return PdfModel.fromList(doc);
        },),);
      },);
      print(_readableResources.length);
    } on Error catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
          content: Text("Unable to load videos check your connection")));
    }
  }
  
  Future<File> getPdf(url) async{
    final pdfRef = FirebaseStorage.instance.ref().child('pdfFiles').child('${url}.pdf');
    final bytes = await pdfRef.getData();
    return storeFile(url, bytes as List<int>);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrimaryEducation();
    getSecondaryEducation();
    getTrendingTopics();
    getReadableResources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SystemUi.systemColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              "Learn",
              style: SystemUi.headerTextStyle,
            ),
            expandedHeight: 50,
            backgroundColor: Colors.deepPurple.shade50,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.deepPurple,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Trending Topics",
                    style: SystemUi.profilePagePTextStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 150,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _trendingTopics.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VideoPlayer(
                                          videoData: _trendingTopics[index],
                                        )));
                          },
                          child: VideoModel(
                            videoSample: _trendingTopics[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Primary Education",
                    style: SystemUi.profilePagePTextStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 150,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _trendingTopics.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoPlayer(
                                      videoData: _primaryEducation[index],
                                    ),
                              ),
                            );
                          },
                          child: VideoModel(
                            videoSample: _primaryEducation[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Secondary Education",
                    style: SystemUi.profilePagePTextStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 150,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _trendingTopics.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoPlayer(
                                      videoData: _secondaryEducation[index],
                                    ),
                              ),
                            );
                          },
                          child: VideoModel(
                            videoSample: _secondaryEducation[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Readable Resources",
                    style: SystemUi.profilePagePTextStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _readableResources.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                                final file = await getPdf(_readableResources[index].title);
                                print(file);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PdfViewerPage(file: file)));
                            },
                              child: ReadableModel(title: _readableResources[index].title),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
