import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:instagram_clone/pageScreens/account_info_screen.dart';
import 'package:instagram_clone/pageScreens/activity_page.dart';
import 'package:instagram_clone/pageScreens/add_a_post.dart';
import 'package:instagram_clone/pageScreens/profile_screen.dart';
import 'package:instagram_clone/pageScreens/search_page.dart';
import 'package:instagram_clone/pageScreens/upload_post.dart';

import '../models/user.dart';
import '../pageScreens/hom_page.dart';

class HomeScreen extends StatefulWidget {
  static String route = "HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  late PageController pageController;

  @override
  void initState()  {
    pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void setPageIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void pageChanged(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.black,
        currentIndex: currentIndex,
        onTap: pageChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],

      ),
      body: PageView(
        controller: pageController,
        onPageChanged: setPageIndex,
        children: [
          HomePage(),
          SearchPage(),
          UploadPost(),
          ActivityPage(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
