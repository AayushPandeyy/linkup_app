import 'package:chatapp_flutter/screens/ChatScreen.dart';
import 'package:chatapp_flutter/services/FirestoreService.dart';
import 'package:chatapp_flutter/widgets/searchScreen/SearchBox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final firestoreService = Firestoreservice();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder(
          stream: firestoreService.getAllBlockedUsers(),
          builder: (context, snapshot) {
            print(snapshot);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: snapshot.data!
                    .map((data) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  lastSeen: data["lastSeen"],
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
                          child: SearchBox(
                            username: data["username"],
                            email: data["email"],
                          ),
                        ))
                    .toList(),
              ),
            );
          }),
    ));
  }
}
