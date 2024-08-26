import 'package:flutter/material.dart';

class ChatDialog extends StatefulWidget {
  final TextDirection direction;
  const ChatDialog({super.key, required this.direction});

  @override
  State<ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          textDirection: widget.direction,
          children: [
            SizedBox(
              width: 3,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.4,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Hello World"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
