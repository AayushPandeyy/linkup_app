import 'package:chatapp_flutter/models/Message.dart';
import 'package:chatapp_flutter/screens/ChatScreen.dart';
import 'package:chatapp_flutter/services/ChatService.dart';
import 'package:chatapp_flutter/services/FirestoreService.dart';
import 'package:chatapp_flutter/widgets/homeScreen/ChatCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User currUser = FirebaseAuth.instance.currentUser!;
  final firestoreService = Firestoreservice();

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
    List<String> ids = [currUser.uid, data["uid"]];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Fetch the latest message using the chatRoomId
    Firestoreservice firestoreService = Firestoreservice();

    return StreamBuilder(
        stream: firestoreService.getLatestMessageByChatroomId(chatRoomId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 208, 205, 205),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ));
          }

          String latestMessage = "Start a conversation";
          bool isSentByYou = false;
          bool hasChatted = true;
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic>? messageData = snapshot.data!.data();
            if (messageData != null && messageData.containsKey('message')) {
              if (messageData["senderId"] == currUser.uid) {
                isSentByYou = true;
              }
              latestMessage = messageData['message'];

              // Display the latest message
            }
          } else if (snapshot.data == null) {
            hasChatted = false;
          }
          if (data["email"] != currUser.email) {
            return hasChatted
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            isActive: data["activityStatus"],
                            profilePictureUrl: data["profilePicture"] ??
                                "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg",
                            receiverUsername: data["username"],
                            receiverEmail: data["email"],
                            receiverId: data["uid"],
                          ),
                        ),
                      );
                    },
                    child: ChatCard(
                      profilePictureUrl: data["profilePicture"] ??
                          "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg",
                      username: data["username"],
                      latestMessage: isSentByYou
                          ? "You: $latestMessage"
                          : latestMessage, // Pass the latest message to the ChatCard
                    ),
                  )
                : Container();
          } else {
            return Container();
          }
        });
  }
}
