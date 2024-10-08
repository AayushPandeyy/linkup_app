import 'package:chatapp_flutter/screens/HomeScreen.dart';
import 'package:chatapp_flutter/screens/ProfileScreen.dart';
import 'package:chatapp_flutter/screens/SearchScreen.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;
  final pages = const [HomeScreen(), SearchScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: selectedPage,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: pages[selectedPage],
    );
  }
}
