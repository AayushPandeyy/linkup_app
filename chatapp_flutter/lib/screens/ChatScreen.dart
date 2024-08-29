import 'dart:async';
import 'dart:io';

import 'package:chatapp_flutter/screens/OtherUserProfile.dart';
import 'package:chatapp_flutter/services/ChatService.dart';
import 'package:chatapp_flutter/widgets/common/CustomButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chatapp_flutter/widgets/chatScreen/ChatDialog.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUsername;
  final String receiverEmail;
  final String receiverId;
  final String profilePictureUrl;
  final bool isActive;
  const ChatScreen(
      {super.key,
      required this.receiverUsername,
      required this.receiverEmail,
      required this.receiverId,
      required this.profilePictureUrl,
      required this.isActive});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isSendingImage = false;
  final lastKey = GlobalKey();
  final FocusNode myFocus = FocusNode();
  final TextEditingController _controller = TextEditingController();

  final chatService = ChatService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User currUser = FirebaseAuth.instance.currentUser!;

  final ImagePicker _picker = ImagePicker();

  File? selectedImage;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
      print(selectedImage);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            CustomButton(
                text: "Send",
                onPress: () async {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Colors.transparent,
                            content: Container(
                              color: Colors.transparent,
                              height: 100,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ));
                  await uploadImageMessage();
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 500));
                  Navigator.pop(context);
                }),
            SizedBox(
              height: 5,
            ),
            CustomButton(
                text: "Cancel", onPress: () => {Navigator.pop(context)}),
          ],
          content: Container(
            height: 200,
            child: Image(image: FileImage(selectedImage!)),
          ),
        ),
      );
    }
  }

  Future<void> uploadImageMessage() async {
    setState(() {
      isSendingImage = true;
    });

    List<String> ids = [widget.receiverId, currUser.uid]..sort();
    String joinedId = ids.join("_");
    String finalId = joinedId + Timestamp.now().toString();
    if (selectedImage == null) {
      return;
    }
    try {
      // Create a reference to the Firebase Storage location
      String filePath = 'messages/${finalId}.jpg';
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(filePath)
          .putFile(selectedImage!);

      // Await the completion of the upload
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print(downloadUrl);

      // Update Firestore with the new profile picture URL

      await sendMessage(downloadUrl, "image");

      print("Uploaded to chat");
      // Show a success message
    } catch (e) {
      // Show error message if upload fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile picture: $e')),
      );
    } finally {
      setState(() {
        isSendingImage = false;
      });
    }
  }

  Future<void> sendMessage(String text, String type) async {
    if (text.isNotEmpty) {
      await chatService.sendMessage(widget.receiverId, text, type);

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
        backgroundColor: Color(0xffF2F3F4),
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
            child: Column(
              children: [
                Text(
                  widget.receiverUsername,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.yellow,
                    fontFamily: "AldotheApache",
                  ),
                ),
                Text(
                  widget.isActive ? "Active Now" : "Offline",
                  style: TextStyle(
                    fontSize: 13,
                    color: widget.isActive ? Colors.green : Colors.grey,
                    fontFamily: "AldotheApache",
                  ),
                ),
              ],
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
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo, color: Colors.red),
                        onPressed: () {
                          pickImage();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.red),
                        onPressed: () {
                          sendMessage(_controller.text, "text");
                        },
                      ),
                    ],
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

    print("Type is : ${data["type"] == "image"}");

    return data['senderId'] == auth.currentUser!.uid
        ? isSeen
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ChatDialog(
                      type: data["type"],
                      isSentByMe: true,
                      color: Color(0xff34495E),
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
                type: data["type"],
                isSentByMe: true,
                color: Color(0xff34495E),
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
                  type: data["type"],
                  isSentByMe: false,
                  color: Colors.grey,
                  direction: TextDirection.ltr,
                  message: data['message']),
            ],
          );
  }
}
