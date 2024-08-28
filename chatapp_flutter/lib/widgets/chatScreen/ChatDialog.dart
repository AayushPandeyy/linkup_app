import 'package:flutter/material.dart';

class ChatDialog extends StatefulWidget {
  final TextDirection direction;
  final Color color;
  final String message;
  final bool isSentByMe;
  const ChatDialog({
    super.key,
    required this.message,
    required this.direction,
    required this.color,
    required this.isSentByMe,
  });

  @override
  State<ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  @override
  Widget build(BuildContext context) {
    return Row(textDirection: widget.direction, children: [
      Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: widget.isSentByMe ? widget.color : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.isSentByMe ? 16 : 0),
            topRight: Radius.circular(widget.isSentByMe ? 0 : 16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: Text(
          widget.message,
          style: TextStyle(
            color: widget.isSentByMe ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    ]);
  }
}
