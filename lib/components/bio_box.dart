import 'package:flutter/material.dart';

class MyBioBox extends StatelessWidget {
  final String text;
  const MyBioBox({super.key,
  required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding outside
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),


      child: Text(text.isNotEmpty ? text: "Empty bio..",
      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}
