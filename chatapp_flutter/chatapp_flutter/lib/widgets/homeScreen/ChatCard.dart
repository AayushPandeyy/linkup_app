import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String username;
  final String latestMessage;
  final String profilePictureUrl;

  const ChatCard({
    super.key,
    required this.username,
    required this.latestMessage,
    required this.profilePictureUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        color: Color(0xff34495E),
        border: Border.symmetric(
          horizontal: BorderSide(color: Color.fromARGB(255, 222, 217, 217)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              foregroundImage: NetworkImage(profilePictureUrl),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontFamily: "MarkoOne",
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xffF4D03F),
                    ),
                    overflow: TextOverflow.ellipsis, // Handle overflow
                  ),
                  Text(
                    latestMessage,
                    style: const TextStyle(
                      fontFamily: "UbuntuMono",
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle overflow
                    maxLines: 1, // Limit to one line
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
