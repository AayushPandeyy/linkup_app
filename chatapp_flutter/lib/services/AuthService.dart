import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // get firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;

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

  //logout
}
