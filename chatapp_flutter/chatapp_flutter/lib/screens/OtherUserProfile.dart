import 'package:chatapp_flutter/screens/auth/SignInScreen.dart';
import 'package:chatapp_flutter/services/FirestoreService.dart';
import 'package:chatapp_flutter/widgets/profileScreen/UserDetailsTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final String email;
  final String username;
  const OtherUserProfileScreen({super.key, required this.email, required this.username});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: Text(
            "${widget.username}'s Details",
            style: TextStyle(
              fontSize: 20,
              color: Colors.yellow,
              fontFamily: "AldotheApache",
            ),
          ),
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: Firestoreservice().getUserDataByEmail(widget.email),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data found'));
            }

            // Assuming there's only one user with this email
            var userData = snapshot.data!.first;


            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      child: CircleAvatar(
                        radius: 90,
                        foregroundImage: NetworkImage(userData[
                                "profilePicture"] ??
                            "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    UserDetailsTile(
                      value: userData["username"] == null ||
                              userData["username"] == ""
                          ? "Not Set"
                          : userData["username"],
                      field: "Username",
                    ),
                    UserDetailsTile(
                      value: userData["email"] ?? "Not Set",
                      field: "Email",
                    ),
                    UserDetailsTile(
                      value: userData["bio"] == null || userData["bio"] == ""
                          ? "Not Set"
                          : userData["bio"],
                      field: "Bio",
                    ),
                    UserDetailsTile(
                      value:
                          userData["phone"] == null || userData["phone"] == ""
                              ? "Not Set"
                              : userData["phone"],
                      field: "Phone",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
    ;
  }
}
