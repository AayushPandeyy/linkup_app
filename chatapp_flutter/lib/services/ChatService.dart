import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  //instance of firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //get users
  Stream<List<Map<String, dynamic>>> getUsers() {
    return firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }
}
