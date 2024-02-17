import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:thevoice2/Models/NewsM.dart';
import 'package:thevoice2/Models/NewsModel.dart';
import 'package:thevoice2/Pages/community.dart';
import 'package:thevoice2/Pages/helptofindbug.dart';
import 'package:thevoice2/Pages/notification.dart';
import 'package:thevoice2/Pages/personalLawyer.dart';
import 'package:thevoice2/SystemUiValues.dart';
import 'package:thevoice2/goalValues.dart';

import '../Authentication/login.dart';
import '../Services/AISercvices/geiminiPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<NewsM> news;

  final ScrollController _controller = ScrollController();

  String userName = "user";

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<NewsM> fetchNews() async {
    final response = await http.get(
      Uri.parse(
          "https://newsdata.io/api/1/news?apikey=pub_3680866a3414929b7b2e17b3429b27d9014b4&q=pizza"),
    );

    var newsData = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return NewsM.fromJson(newsData);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future getUserName() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserId)
        .get()
        .then(
      (value) {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;
        setState(() {
          userName = data['name'];
          if (kDebugMode) {
            print(userName);
          }
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    news = fetchNews();
    if (kDebugMode) {
      print(news);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SystemUi.systemColor,
      drawer: Drawer(
          backgroundColor: SystemUi.systemColor,
          child: ListView(
            children: [
              DrawerHeader(
                  curve: Curves.easeInOut,
                  decoration: const BoxDecoration(color: Colors.deepPurple),
                  child: Text(
                    userName,
                    style: SystemUi.headerTextStyle,
                  )),
              ListTile(
                leading: const Icon(
                  Icons.send,
                  color: Colors.black,
                ),
                title: Text(
                  "AI Assistant",
                  style: GoogleFonts.roboto(color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GeminiPage()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.help,
                  color: Colors.black,
                ),
                title: Text(
                  "Need Help?",
                  style: GoogleFonts.roboto(color: Colors.black),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.bug_report,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HeplToBug()));
                },
                title: Text(
                  "Help to find bug",
                  style: GoogleFonts.roboto(color: Colors.black),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PersonalLawyer()));
                },
                title: Text(
                  "Get Personal Lawyer",
                  style: GoogleFonts.roboto(color: Colors.black),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  "Log out",
                  style: GoogleFonts.roboto(color: Colors.red),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => new LoginPage()),
                      (route) => false,
                    );
                  });
                },
              )
            ],
          )),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple.shade100,
            expandedHeight: 50,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.deepPurple,
              ),
              title: Text("THE VOICE",
                  style: SystemUi.headerTextStyle, textAlign: TextAlign.center),
            ),
            floating: false,
            pinned: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationPage()));
                },
                icon: const Icon(
                  Icons.notification_add_outlined,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Community()));
                },
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: () {
                return news = fetchNews();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // container for the greeting
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Hi $userName",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold, fontSize: 36),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CarouselSlider.builder(
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Theme.of(context).focusColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Image(
                            image: GoalValues.goalsList[itemIndex],
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                      options: CarouselOptions(
                        height: 150,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 3000),
                        autoPlayCurve: Curves.easeInOut,
                        enlargeCenterPage: false,
                        enlargeFactor: 0.1,
                        scrollPhysics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                  Center(
                    child: FutureBuilder(
                      future: fetchNews(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            controller: _controller,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.results?.length,
                            itemBuilder: (context, index) {
                              return NewsModel(
                                  summary: snapshot
                                      .data!.results?[index].description,
                                  link: snapshot.data!.results?[index].imageUrl,
                                  title: snapshot.data!.results?[index].title);
                            },
                          );
                        }
                        if (snapshot.hasError) {
                          return Text("Unable to load ${snapshot.error}");
                        }

                        return const CircularProgressIndicator(
                          color: Colors.deepPurple,
                          strokeCap: StrokeCap.round,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
