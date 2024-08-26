import 'package:chatapp_flutter/models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //instance of firestore and firebase auth
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  //get users
  Stream<List<Map<String, dynamic>>> getUsers() {
    return firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverId, message) async {
    final User currUser = auth.currentUser!;
    final senderId = currUser.uid;
    final senderEmail = currUser.email;

    Message newMessage = Message(
        message: message,
        senderEmail: senderEmail!,
        senderId: senderId,
        receiverId: receiverId,
        timestamp: Timestamp.now());

    List<String> ids = [receiverId, senderId];
    ids.sort();
    String chatroomId = ids.join('_');

    await firestore
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, otherId) {
    List<String> ids = [userId, otherId];
    ids.sort();
    String chatroomId = ids.join('_');
    return firestore
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots();
  }
}
