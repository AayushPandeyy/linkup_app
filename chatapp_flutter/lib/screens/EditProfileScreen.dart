import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Colors.green,
          elevation: 0,
        ),
        body: SingleChildScrollView(
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
                            // Implement save functionality
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
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            // Implement cancel functionality
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side:
                                const BorderSide(color: Colors.green, width: 2),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
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
