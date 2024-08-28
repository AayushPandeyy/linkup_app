import 'package:chatapp_flutter/screens/ChatScreen.dart';
import 'package:chatapp_flutter/services/ChatService.dart';
import 'package:chatapp_flutter/widgets/common/CustomTextField.dart';
import 'package:chatapp_flutter/widgets/searchScreen/SearchBox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ChatService chatService = ChatService();
  final TextEditingController searchController = TextEditingController();

  String? query = "";
  final User currUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          children: [
            CustomTextField(
              onChanged: () {
                setState(() {
                  query = searchController.text;
                });
              },
              controller: searchController,
              placeholder: "Search for users",
            ),
            Expanded(
              child: StreamBuilder(
                stream: chatService.searchUsers(query!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty ) {
                    return Center(
                        child: Text("No users found",
                            style: TextStyle(color: Colors.white)));
                  }

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
                                        profilePictureUrl: data["profilePicture"] ?? "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg",
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
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
