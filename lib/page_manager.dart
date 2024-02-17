import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thevoice2/Home/home.dart';
import 'package:thevoice2/Learning/Learning.dart';
import 'package:thevoice2/Profile/Profile.dart';
import 'package:thevoice2/Report/Report.dart';
import 'package:thevoice2/SystemUiValues.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;

  static const  List<Widget> _widgetList = [
    HomePage(),
    ReportIncident(),
    LearingPlace(),
    Profile()
  ];

  void _onTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: SystemUi.systemColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Center(
            child: _widgetList.elementAt(_selectedIndex),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items:  [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home, color: Colors.grey,),
            activeIcon: const Icon(Icons.home_filled),
            label: "Home",
            backgroundColor: SystemUi.systemColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search, color: Colors.grey,),
            activeIcon: const Icon(Icons.search_outlined),
            label: "Report",
            backgroundColor: SystemUi.systemColor,

          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.class_, color: Colors.grey,),
            activeIcon: const Icon(Icons.class_outlined),
            label: "Learning",
            backgroundColor: SystemUi.systemColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person,  color: Colors.grey,),
            activeIcon: const Icon(Icons.person_2_outlined),
            label: "Profile",
            backgroundColor: SystemUi.systemColor,
          )
        ],
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        iconSize:22,
        elevation: 0,
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onTapped,
      ),
    );
  }
}
