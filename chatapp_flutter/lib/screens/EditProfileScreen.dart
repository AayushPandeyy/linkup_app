import 'dart:io';

import 'package:chatapp_flutter/screens/ProfileScreen.dart';
import 'package:chatapp_flutter/services/FirestoreService.dart';
import 'package:chatapp_flutter/widgets/common/CustomButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  final ImagePicker _picker = ImagePicker();

  File? selectedImage;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
      print(selectedImage);
    }
  }

  Future<void> uploadProfilePicture() async {
    if (selectedImage == null) {
      return;
    }
    try {
      // Create a reference to the Firebase Storage location
      String filePath = 'profile_pictures/${currUser.uid}.jpg';
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(filePath)
          .putFile(selectedImage!);

      // Await the completion of the upload
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with the new profile picture URL
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currUser.uid)
          .update({'profilePicture': downloadUrl});

      // Show a success message
    } catch (e) {
      // Show error message if upload fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile picture: $e')),
      );
    }
  }

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
        await firestoreService.updateUserDetails(
            usernameController.text,
            emailController.text,
            bioController.text,
            phoneController.text,
            context);
        await uploadProfilePicture();
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
                          height: 210,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 225, 231, 225),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                              radius: 95,
                              backgroundImage: selectedImage == null
                                  ? NetworkImage(
                                      userData["profilePicture"] ??
                                          "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg", // Replace with actual profile picture URL
                                    )
                                  : FileImage(selectedImage!)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                        text: "Choose a profile picture",
                        onPress: () {
                          pickImage();
                        }),
                    const SizedBox(height: 20),
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
