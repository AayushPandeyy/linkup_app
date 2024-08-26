import 'package:chatapp_flutter/widgets/common/CustomTextField.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          children: [
            CustomTextField(
              placeholder: "Search for users",
            )
          ],
        ),
      ),
    ));
  }
}
