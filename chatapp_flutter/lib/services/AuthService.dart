import 'package:chatapp_flutter/services/FirestoreService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // get firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firestoreService = Firestoreservice();

  //signIn
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user;
    } on FirebaseAuthException catch (err) {
      print("FirebaseAuthException: ${err.code} - ${err.message}");
      // Re-throwing the FirebaseAuthException with both code and message
      throw FirebaseAuthException(
        code: err.code,
        message: err.message,
      );
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception('An unexpected error occurred');
    }
  }

  //signUp

  Future<UserCredential> signUp(
      String email, String password, String username) async {
    print("check");
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firestoreService.addUserToDatabase(user.user!.uid, email, username);
      if (!user.user!.emailVerified) {
        await user.user!.sendEmailVerification();
      }
      print(user);

      await FirebaseAuth.instance.signOut();
      return user;
    } on FirebaseAuthException catch (err) {
      print(err);
      throw Exception(err);
    }
  }

  //logout

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
