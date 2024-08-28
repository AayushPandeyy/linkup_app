import 'package:chatapp_flutter/screens/ProfileScreen.dart';
import 'package:chatapp_flutter/services/FirestoreService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = false;

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController bioController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final User currUser = FirebaseAuth.instance.currentUser!;

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dialog from being closed manually
      builder: (context) => PopScope(
        onPopInvoked: (bool) => false, // Prevents back navigation
        child: AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Updating Your Details. Please Wait."),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Firestoreservice();
    void updateData() async {
      showLoadingDialog();
      setState(() {
        isLoading = true;
      });
      try {
        if (usernameController.text.isEmpty || emailController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please fill email and username")));
        }
        await firestoreService.updateUserDetails(usernameController.text,
            emailController.text, bioController.text, phoneController.text);
        Navigator.pop(context);
      } catch (err) {
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Colors.green,
          elevation: 0,
        ),
        body: StreamBuilder(
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

              usernameController.text = userData["username"];
              emailController.text = userData["email"];
              bioController.text =
                  userData["bio"] == null ? "" : userData["bio"];
              phoneController.text =
                  userData["phone"] == null ? "" : userData["phone"];
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 225, 231, 225),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 55,
                              backgroundImage: NetworkImage(
                                "https://static.vecteezy.com/system/resources/previews/011/490/381/non_2x/happy-smiling-young-man-avatar-3d-portrait-of-a-man-cartoon-character-people-illustration-isolated-on-white-background-vector.jpg", // Replace with actual profile picture URL
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 160,
                          right: MediaQuery.of(context).size.width / 2 - 40,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              // Implement profile picture change functionality
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildTextField(
                            label: 'Username',
                            controller: usernameController,
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            disabled: true,
                            label: 'Email',
                            controller: emailController,
                            icon: Icons.email,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Bio',
                            controller: bioController,
                            icon: Icons.info,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Phone Number',
                            controller: phoneController,
                            icon: Icons.phone,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  updateData();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  // Implement cancel functionality
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: const BorderSide(
                                      color: Colors.green, width: 2),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget _buildTextField({
    bool? disabled,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      readOnly: disabled == null ? false : disabled,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 152, 193, 153)),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.green),
        filled: true,
        fillColor: Colors.green[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
