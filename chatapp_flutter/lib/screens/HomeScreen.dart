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
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Logged in user is :${currUser.email}");
  }

  @override
  Widget build(BuildContext context) {
    final ChatService chatService = ChatService();
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "LinkUp",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "AldotheApache",
                ),
              ),
              elevation: 4,
            ),
            body: Container(
                margin: EdgeInsets.only(top: 1),
                height: double.maxFinite,
                child: StreamBuilder(
                  stream: chatService.getUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
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
                          receiverEmail: data["email"],
                          receiverId: data["uid"],
                        )));
          },
          child: ChatCard(username: data["username"]));
    } else {
      return Container();
    }
  }
}
