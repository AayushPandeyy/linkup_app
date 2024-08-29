import 'package:chatapp_flutter/firebase_options.dart';
import 'package:chatapp_flutter/screens/LoginChecker.dart';
import 'package:chatapp_flutter/screens/auth/SignInScreen.dart';
import 'package:chatapp_flutter/services/FirestoreService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Firestoreservice().changeActivityStatus(
        false); // Set user as offline when the app is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // User returned to the app, set status to online
        Firestoreservice().changeActivityStatus(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        // User left the app or minimized it, set status to offline
        Firestoreservice().changeActivityStatus(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginChecker(),
      debugShowCheckedModeBanner: false,
    );
  }
}
