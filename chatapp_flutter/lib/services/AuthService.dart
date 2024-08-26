import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // get firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //signIn
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
          
      return user;
    } on FirebaseAuthException catch (err) {
      print(err);
      throw Exception(err);
    }
  }

  //signUp

  Future<UserCredential> signUp(String email, String password,username) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      firestore.collection("Users").doc(user.user!.uid).set({
            'uid':user.user!.uid,
            "email":email,
            "username":username

    });

      return user;
    } on FirebaseAuthException catch (err) {
      print(err);
      throw Exception(err);
    }
  }

  //logout

  Future<void> logout() async {
    return await auth.signOut();
  }
}
