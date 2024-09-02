import 'package:chatapp_flutter/screens/BlockedUsersScreen.dart';
import 'package:chatapp_flutter/screens/EditProfileScreen.dart';
import 'package:chatapp_flutter/screens/ProfileScreen.dart';
import 'package:chatapp_flutter/screens/SearchScreen.dart';
import 'package:chatapp_flutter/screens/auth/SignInScreen.dart';
import 'package:chatapp_flutter/services/AuthService.dart';
import 'package:chatapp_flutter/services/FirestoreService.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final firestoreService = Firestoreservice();
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2,
      width: MediaQuery.sizeOf(context).width * 0.18,
      backgroundColor: Colors.black.withOpacity(0.4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DrawerTile(Icons.home, () {
            Navigator.pop(context);
          }),
          DrawerTile(Icons.search, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen()));
          }),
          DrawerTile(Icons.person, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }),
          DrawerTile(Icons.settings, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()));
          }),
          // DrawerTile(Icons.block, () {
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => BlockedUsersScreen()));
          // }),
          DrawerTile(Icons.logout, () async {
            await firestoreService.changeActivityStatus(false);
            await authService.logout();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          })
        ],
      ),
    );
  }

  Widget DrawerTile(IconData icon, VoidCallback onPressed) {
    return Column(
      children: [
        Container(
          height: 60,
          // color: Colors.white,
          child: GestureDetector(
            onTap: () {
              onPressed();
            },
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
