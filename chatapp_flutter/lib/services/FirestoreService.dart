import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> updateUserEmail(String newEmail) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updateEmail(newEmail);
        await user.reload(); // Reload the user to reflect changes
        user = FirebaseAuth.instance.currentUser; // Get updated user

        print("Email updated successfully");
      } on FirebaseAuthException catch (e) {
        print("Failed to update email: ${e.message}");
      }
    }
  }

  Future<void> updateUserDetails(String username, email, bio, phone) async {
    try {
      DocumentReference userDoc =
          firestore.collection("Users").doc(currUser.uid);
      await userDoc.update(
          {"username": username, "email": email, "bio": bio, "phone": phone});
      await updateUserEmail(email);

      print("Updated");
    } catch (err) {
      print("Error : $err");
    }
  }
}
