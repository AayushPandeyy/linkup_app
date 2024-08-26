import 'package:chatapp_flutter/providers/AuthProvider.dart';
import 'package:chatapp_flutter/screens/MainPage.dart';
import 'package:chatapp_flutter/screens/auth/SignInScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await verifyAndLoadData();
    });
  }

  Future<void> verifyAndLoadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.getUser();

    // Run both verification and game fetching in parallel
    await Future.wait([
      authProvider.verify_token(),
    ]);

    await Future.delayed(const Duration(seconds: 2));

    if (authProvider.isLogged != null &&
        authProvider.isLogged! &&
        !authProvider.isLoading) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        // color: Color(0xffFEF9E6),
        color: Colors.black,
        child: const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              // color: ,
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            )
          ],
        )),
      ),
    ));
  }
}
