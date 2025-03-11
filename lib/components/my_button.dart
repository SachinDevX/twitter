import 'package:flutter/material.dart';
class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyButton({super.key,
  required this.onTap,
  required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),

        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,

          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),),
      ),
    );
  }
}
