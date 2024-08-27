import 'package:flutter/material.dart';

class UserDetailsTile extends StatelessWidget {
  final String field;
  final String value;
  const UserDetailsTile({super.key, required this.value, required this.field});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width * 0.9,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 208, 206, 206),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  field,
                  style: TextStyle(fontFamily: "AldotheApache"),
                ),
                SizedBox(
                  width: 50,
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.right,
                    value,
                    style: TextStyle(
                        fontFamily: "SpaceGrotesk",
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
