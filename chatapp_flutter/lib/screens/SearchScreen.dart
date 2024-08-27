import 'package:chatapp_flutter/screens/ChatScreen.dart';
import 'package:chatapp_flutter/services/ChatService.dart';
import 'package:chatapp_flutter/widgets/common/CustomTextField.dart';
import 'package:chatapp_flutter/widgets/common/SearchBox.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

final ChatService chatService = ChatService();
final searchController = TextEditingController();

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    String query = "";
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          children: [
            CustomTextField(
              onChanged: () {
                query = searchController.text;
              },
              controller: searchController,
              placeholder: "Search for users",
            ),
            Expanded(
              child: StreamBuilder(
                stream: chatService.searchUsers(query),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No users found"));
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
                                                  receiverUsername:
                                                      data["username"],
                                                  receiverEmail: data["email"],
                                                  receiverId: data["uid"],
                                                )));
                                  },
                                  child: SearchBox(
                                      username: data["username"],
                                      email: data["email"]),
                                ))
                            .toList()),
                  );
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
