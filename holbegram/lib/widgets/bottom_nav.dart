import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/screens/pages/feed.dart';
import 'package:holbegram/screens/pages/search.dart';
import 'package:holbegram/screens/pages/add_image.dart';
import 'package:holbegram/screens/pages/favorite.dart';
import 'package:holbegram/screens/pages/profile_screen.dart';


// Class to manage navigation between pages
class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  BottomNavState createState() => BottomNavState();
}

// Class to manage the state of navigation between pages
class BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  late PageController _pageController;

  // initState function to initialize the page controller
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  // Releases the resources used by the page controller
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Function to change the page
  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          Feed(),
          Search(),
          AddImage(),
          Favorite(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: onPageChanged,
        items: [
          // Navigation bar for Home pages
          BottomNavyBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Home', style: TextStyle(fontFamily: 'Billabong', fontSize: 25)),
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
          ),

          // Navigation bar for Search pages
          BottomNavyBarItem(
            icon: const Icon(Icons.search),
            title: const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Search', style: TextStyle(fontFamily: 'Billabong', fontSize: 25)),
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
          ),

          // Navigation bar for Add pages
          BottomNavyBarItem(
            icon: const Icon(Icons.add),
            title: const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Add', style: TextStyle(fontFamily: 'Billabong', fontSize: 25)),
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
          ),

          // Navigation bar for Favorite pages
          BottomNavyBarItem(
            icon: const Icon(Icons.favorite_outline),
            title: const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text('Favorite', style: TextStyle(fontFamily: 'Billabong', fontSize: 25)),
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
          ),

          // Navigation bar for Profile pages
          BottomNavyBarItem(
            icon: const Icon(Icons.person_outline),
            title: const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Profile', style: TextStyle(fontFamily: 'Billabong', fontSize: 25)),
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
