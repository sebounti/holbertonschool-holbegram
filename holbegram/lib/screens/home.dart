import 'package:flutter/material.dart';
import 'package:holbegram/widgets/bottom_nav.dart';

// Class to manage the home page
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BottomNav(),
    );
  }
}
