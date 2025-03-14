import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/firebase_options.dart';
import 'package:twitter/pages/Register_page.dart';
import 'package:twitter/pages/home_page.dart';
import 'package:twitter/pages/login_page.dart';
import 'package:twitter/services/auth/Login_Or_Register.dart';
import 'package:twitter/services/auth/auth_gate.dart';
import 'package:twitter/themes/dark_mode.dart';
import 'package:twitter/themes/light_mode.dart';
import 'package:twitter/themes/theme_provider.dart';
import 'package:twitter/services/database/database_provider.dart';

void main() async {
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  //run app
  runApp(
    MultiProvider(
        providers: [
          //theme provider
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          //database provider
          ChangeNotifierProvider(create: (context) => DataBaseProvider()),
        ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
