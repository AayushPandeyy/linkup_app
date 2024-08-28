import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Firestoreservice {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User currUser = FirebaseAuth.instance.currentUser!;

  Stream<List<Map<String, dynamic>>> getUserDataByEmail(String email) {
    return FirebaseFirestore.instance
        .collection('Users') // The name of your collection
        .where('email', isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }


  Future<void> updateUserDetails(String username, email, bio, phone,BuildContext context) async {
    try {
      DocumentReference userDoc =
          firestore.collection("Users").doc(currUser.uid);
      await userDoc.update(
          {"username": username, "email": email, "bio": bio, "phone": phone});

    } catch (err) {
      showDialog(
        context: context,
        builder: (context) =>
            Container(child: AlertDialog(content: Text("Error : $err"))));
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>?> getLatestMessageByChatroomId(
      String chatroomId) {
    try {
      // Query to listen to the latest message from the specified chat room
      return firestore
          .collection("chat_rooms")
          .doc(chatroomId)
          .collection("messages")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        // Return the first document if available, otherwise null
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first;
        }
        return null;
      });
    } catch (e) {
      // Handle any errors that occur during the fetch
      print("Error fetching latest message: $e");
      return Stream.value(null);
    }
  }
  
}
