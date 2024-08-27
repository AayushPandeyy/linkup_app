import 'package:chatapp_flutter/screens/EditProfileScreen.dart';
import 'package:chatapp_flutter/screens/auth/SignInScreen.dart';
import 'package:chatapp_flutter/services/AuthService.dart';
import 'package:chatapp_flutter/widgets/common/CustomButton.dart';
import 'package:chatapp_flutter/widgets/profileScreen/UserDetailsTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250,
                child: const CircleAvatar(
                  radius: 90,
                  foregroundImage: NetworkImage(
                      "https://static.vecteezy.com/system/resources/previews/011/490/381/non_2x/happy-smiling-young-man-avatar-3d-portrait-of-a-man-cartoon-character-people-illustration-isolated-on-white-background-vector.jpg"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => EditProfileScreen()));
                },
                child: Container(
                  height: 40,
                  width: 125,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Edit User Details",
                        style: const TextStyle(
                            fontFamily: "Gabarito",
                            fontSize: 15,
                            color: Colors.pink),
                      ),
                      Icon(
                        Icons.edit,
                        size: 17,
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              UserDetailsTile(value: "Astened", field: "Username"),
              UserDetailsTile(value: "ap200061@gmail.com", field: "Email"),
              UserDetailsTile(
                  value:
                      "So you think you can tell, heaven from hell blue skies in pain",
                  field: "Bio"),
              UserDetailsTile(value: "9849305128", field: "Phone"),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                  text: "Sign Out",
                  onPress: () async {
                    final AuthService authService = AuthService();
                    await authService.logout();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  }),
            ],
          ),
        ),
      ),
    ));
  }
}
