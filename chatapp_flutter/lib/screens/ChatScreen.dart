import 'dart:async';

import 'package:chatapp_flutter/screens/OtherUserProfile.dart';
import 'package:chatapp_flutter/services/ChatService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp_flutter/widgets/chatScreen/ChatDialog.dart';
import 'package:flutter/scheduler.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUsername;
  final String receiverEmail;
  final String receiverId;
  final String profilePictureUrl;
  const ChatScreen(
      {super.key,
      required this.receiverUsername,
      required this.receiverEmail,
      required this.receiverId,
      required this.profilePictureUrl});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final lastKey = GlobalKey();
  final FocusNode myFocus = FocusNode();
  final TextEditingController _controller = TextEditingController();

  final chatService = ChatService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User currUser = FirebaseAuth.instance.currentUser!;

  void sendMessage() async {
    if (_controller.text.isNotEmpty) {
      chatService.sendMessage(widget.receiverId, _controller.text);

      _controller.text = "";
      scrollToBottom();
    }
  }

  void markMessagesAsSeen(String chatId) async {
    final messageSnapshot = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatId)
        .collection("messages")
        .where("seen", isEqualTo: false)
        .where("receiverId", isEqualTo: currUser.uid)
        .get();
    for (var doc in messageSnapshot.docs) {
      await doc.reference.update({"seen": true});
    }
  }

  final ScrollController scrollController = ScrollController();
  final senderId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    final chatroomId = [
      widget.receiverId,
      senderId,
    ]..sort();
    markMessagesAsSeen(chatroomId.join("_"));

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // User has scrolled to the bottom, you might want to fetch more messages or handle this state
      }
    });

    myFocus.addListener(() {
      if (myFocus.hasFocus) {
        Future.delayed(
            const Duration(milliseconds: 700), () => scrollToBottom());
      }
    });
  }

  @override
  void dispose() {
    myFocus.dispose();
    _controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 200,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OtherUserProfileScreen(
                            email: widget.receiverEmail,
                            username: widget.receiverUsername,
                          )));
            },
            child: Text(
              widget.receiverUsername,
              style: TextStyle(
                fontSize: 20,
                color: Colors.yellow,
                fontFamily: "AldotheApache",
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: StreamBuilder(
                    stream:
                        chatService.getMessages(senderId, widget.receiverId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final chatroomId = [
                          widget.receiverId,
                          senderId,
                        ]..sort();
                        markMessagesAsSeen(chatroomId.join("_"));
                        scrollToBottom();
                      });

                      return ListView(
                        controller: scrollController,
                        children: snapshot.data!.docs
                            .map((doc) => DisplayMessageWidget(doc))
                            .toList(),
                      );
                    }),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        focusNode: myFocus,
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.red),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget DisplayMessageWidget(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isSeen = data["seen"];

    return data['senderId'] == auth.currentUser!.uid
        ? isSeen
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ChatDialog(
                      isSentByMe: true,
                      color: Colors.green,
                      direction: TextDirection.rtl,
                      message: data['message']),
                  SizedBox(width: 2),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.check,
                        size: 20,
                        color: Colors.green,
                      )),
                ],
              )
            : ChatDialog(
                isSentByMe: true,
                color: Colors.green,
                direction: TextDirection.rtl,
                message: data['message'])
        : Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtherUserProfileScreen(
                              username: widget.receiverUsername,
                              email: widget.receiverEmail)));
                },
                child: CircleAvatar(
                  radius: 20,
                  foregroundImage: NetworkImage(widget.profilePictureUrl),
                ),
              ),
              SizedBox(width: 5),
              ChatDialog(
                  isSentByMe: false,
                  color: Colors.grey,
                  direction: TextDirection.ltr,
                  message: data['message']),
            ],
          );
  }
}
