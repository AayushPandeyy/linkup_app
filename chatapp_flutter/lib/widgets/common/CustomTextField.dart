import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onChanged;
  final VoidCallback? onClear;
  const CustomTextField({super.key, this.controller, this.onChanged,this.onClear});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        controller!.text = value;
        onChanged!();
      },
      style: TextStyle(color: Colors.white),
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.pink,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.grey[400],
          ),
          onPressed: () {
            controller!.text = "";
            onClear!();
          },
        ),
      ),
    );
  }
}
