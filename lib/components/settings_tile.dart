import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/themes/theme_provider.dart';

class MySettingsTile extends StatelessWidget {
  final String title;
  final Widget action;
  const MySettingsTile({super.key,
    required this.title,
    required this.action,
  }

);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(left: 25,right: 25, top: 10),

      padding: EdgeInsets.all(25),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          action,
        ],
      )
    );
  }
}
