import 'package:chatapp_flutter/screens/EditProfileScreen.dart';
import 'package:chatapp_flutter/screens/auth/SignInScreen.dart';
import 'package:chatapp_flutter/services/AuthService.dart';
import 'package:chatapp_flutter/services/FirestoreService.dart';
import 'package:chatapp_flutter/widgets/common/CustomButton.dart';
import 'package:chatapp_flutter/widgets/profileScreen/UserDetailsTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
final User currUser = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: Firestoreservice().getUserDataByEmail(currUser.email!),
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
                      child: const CircleAvatar(
                        radius: 90,
                        foregroundImage: NetworkImage(
                            "https://static.vecteezy.com/system/resources/previews/011/490/381/non_2x/happy-smiling-young-man-avatar-3d-portrait-of-a-man-cartoon-character-people-illustration-isolated-on-white-background-vector.jpg"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 135,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.pink),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Edit User Details",
                              style: const TextStyle(
                                fontFamily: "Gabarito",
                                fontSize: 15,
                                color: Colors.pink,
                              ),
                            ),
                            Icon(
                              Icons.edit,
                              size: 17,
                              color: Colors.pink,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    UserDetailsTile(
                      value: userData["username"] ?? "Not Set",
                      field: "Username",
                    ),
                    UserDetailsTile(
                      value: userData["email"] ?? "Not Set",
                      field: "Email",
                    ),
                    UserDetailsTile(
                      value: userData["bio"] ?? "Not Set",
                      field: "Bio",
                    ),
                    UserDetailsTile(
                      value: userData["phone"] ?? "Not Set",
                      field: "Phone",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      text: "Sign Out",
                      onPress: () async {
                        final AuthService authService = AuthService();
                        try {
                          // Perform sign out
                          await authService.logout();

                          // Navigate to SignInScreen and replace the current screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        } catch (e) {
                          // Handle any errors during sign out
                          print('Sign out failed: $e');
                          // Optionally show an error message to the user here
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Sign out failed. Please try again.'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
