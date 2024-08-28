import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  const CustomButton({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        height: 50,
        // width: 175,
        width: MediaQuery.sizeOf(context).width * 0.6,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.pink),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(
          text,
          style: const TextStyle(
              fontFamily: "Gabarito", fontSize: 20, color: Colors.pink),
        )),
      ),
    );
  }
}
