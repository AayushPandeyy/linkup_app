import 'package:chatapp_flutter/screens/HomeScreen.dart';
import 'package:chatapp_flutter/screens/auth/SignInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginChecker extends StatefulWidget {
  const LoginChecker({super.key});

  @override
  State<LoginChecker> createState() => _LoginCheckerState();
}

class _LoginCheckerState extends State<LoginChecker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
      if(snapshot.hasData){
        return const HomeScreen();
      }else{
        return const SignInScreen();
      }
    }));
  }
}