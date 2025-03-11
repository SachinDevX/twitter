import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/pages/home_page.dart';
import 'package:twitter/pages/login_page.dart';
import 'package:twitter/themes/dark_mode.dart';
import 'package:twitter/themes/light_mode.dart';
import 'package:twitter/themes/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context)=> ThemeProvider(),
        child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
