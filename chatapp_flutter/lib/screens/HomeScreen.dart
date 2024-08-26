import 'package:chatapp_flutter/screens/ChatScreen.dart';
import 'package:chatapp_flutter/widgets/homeScreen/ChatCard.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Chat App",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "AldotheApache",
                ),
              ),
              elevation: 4,
            ),
            body: Container(
                height: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < 10; i++)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ChatScreen()));
                          },
                          child: const ChatCard(),
                        )
                    ],
                  ),
                ))));
  }
}
