import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String username;
  const ChatCard({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      // height: 80,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0),
          border: Border.symmetric(
              horizontal:
                  BorderSide(color: Color.fromARGB(255, 222, 217, 217)))),
      child:  Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              foregroundImage: NetworkImage(
                  "https://static.vecteezy.com/system/resources/previews/011/490/381/non_2x/happy-smiling-young-man-avatar-3d-portrait-of-a-man-cartoon-character-people-illustration-isolated-on-white-background-vector.jpg"),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                      fontFamily: "Gabarito",
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.yellow),
                ),
                const Text(
                  "hya nai aja ta hudaina hai yo kura..voli garamla",
                  style: TextStyle(
                      fontFamily: "Gabarito",
                      fontSize: 15,
                      color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
