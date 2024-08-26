import 'package:chatapp_flutter/screens/ChatScreen.dart';
import 'package:chatapp_flutter/services/ChatService.dart';
import 'package:chatapp_flutter/widgets/homeScreen/ChatCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User currUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    final ChatService chatService = ChatService();
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
                child: StreamBuilder(
                  stream: chatService.getUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading...");
                    }

                    return ListView(
                      children: snapshot.data!
                          .map((data) => DisplayUserWidget(data, context))
                          .toList(),
                    );
                  },
                ))));
  }

  Widget DisplayUserWidget(Map<String, dynamic> data, BuildContext context) {
    if (data["email"] != currUser.email) {
      return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          receiverUsername: data["username"],
                        )));
          },
          child: ChatCard(username: data["username"]));
    } else {
      return Container();
    }
  }
}
