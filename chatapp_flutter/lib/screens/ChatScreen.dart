import 'package:flutter/material.dart';
import 'package:chatapp_flutter/widgets/common/ChatDialog.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUsername;
  const ChatScreen({super.key, required this.receiverUsername});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            widget.receiverUsername,
            style: TextStyle(
              fontSize: 20,
              color: Colors.yellow,
              fontFamily: "AldotheApache",
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < 15; i++)
                      ChatDialog(
                          direction: i % 2 == 0
                              ? TextDirection.ltr
                              : TextDirection.rtl)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.red),
                    onPressed: () {
                      // Handle sending message
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
