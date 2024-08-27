import 'package:chatapp_flutter/services/ChatService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp_flutter/widgets/common/ChatDialog.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUsername;
  final String receiverEmail;
  final String receiverId;
  const ChatScreen(
      {super.key,
      required this.receiverUsername,
      required this.receiverEmail,
      required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FocusNode myFocus = FocusNode();
  final TextEditingController _controller = TextEditingController();

  final chatService = ChatService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  void sendMessage() async {
    if (_controller.text.isNotEmpty) {
      chatService.sendMessage(widget.receiverId, _controller.text);

      _controller.text = "";

      scrollDown();
    }
  }

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    myFocus.addListener(() {
      if (myFocus.hasFocus) {
        Future.delayed(const Duration(seconds: 1), () => scrollDown());
      }
    });
    Future.delayed(const Duration(milliseconds: 1000), () => scrollDown());
  }

  @override
  void dispose() {
    myFocus.dispose();
    _controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(
        scrollController.position.maxScrollExtent,
      );
    }
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
          title: Text(
            widget.receiverUsername,
            style: TextStyle(
              fontSize: 20,
              color: Colors.yellow,
              fontFamily: "AldotheApache",
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView(
                          controller: scrollController,
                          children: snapshot.data!.docs
                              .map((doc) => DisplayMessageWidget(doc))
                              .toList(),
                        );
                      })),
              Row(
                children: [
                  Expanded(
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
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.red),
                    onPressed: () {
                      // Handle sending message
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

    return data['senderId'] == auth.currentUser!.uid
        ? ChatDialog(
            isSentByMe: true,
            color: Colors.green,
            direction: TextDirection.rtl,
            message: data['message'])
        : ChatDialog(
            isSentByMe: false,
            color: Colors.grey,
            direction: TextDirection.ltr,
            message: data['message']);
  }
}
