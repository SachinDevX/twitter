import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter/pages/home_page.dart';
import 'package:twitter/services/auth/Login_Or_Register.dart';
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            //if user is logged in
            if (snapshot.hasData){
              return const HomePage();
            }
            //user is NOT logged in
            else{
              return Login_OR_Register();
            }
           }
          ),
    );
  }
}
