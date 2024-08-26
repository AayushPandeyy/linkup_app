import 'package:flutter/material.dart';

class ChatDialog extends StatefulWidget {
  final TextDirection direction;
  final Color color;
  final String message;
  const ChatDialog({
    super.key,
    required this.message,
    required this.direction,
    required this.color,
  });

  @override
  State<ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          textDirection: widget.direction,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.4,
              decoration: BoxDecoration(
                  color: widget.color,
                  border: Border.all(color: widget.color),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.message,
                  style: TextStyle(fontFamily: "Gabarito", fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
