import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String username;
  final String latestMessage;
  const ChatCard(
      {super.key, required this.username, required this.latestMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      // height: 80,
      decoration: const BoxDecoration(
          color: Color(0xff34495E),
          border: Border.symmetric(
              horizontal:
                  BorderSide(color: Color.fromARGB(255, 222, 217, 217)))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              foregroundImage: NetworkImage(
                  "https://static.vecteezy.com/system/resources/previews/011/490/381/non_2x/happy-smiling-young-man-avatar-3d-portrait-of-a-man-cartoon-character-people-illustration-isolated-on-white-background-vector.jpg"),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                      fontFamily: "MarkoOne",
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xffF4D03F)),
                ),
                Text(
                  latestMessage,
                  style: const TextStyle(
                      fontFamily: "UbuntuMono",
                      // fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
