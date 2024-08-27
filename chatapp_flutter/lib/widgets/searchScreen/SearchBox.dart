import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final String username;
  final String email;
  const SearchBox({super.key, required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: MediaQuery.sizeOf(context).width * 0.9,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              username,
              style: TextStyle(color: Colors.black),
            ),
            Text(
              email,
              style: TextStyle(color: Colors.grey),
            ),
          ]),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
