import 'package:flutter/material.dart';
import 'package:twitter/pages/Register_page.dart';
import 'package:twitter/pages/login_page.dart';

class Login_OR_Register extends StatefulWidget {
  const Login_OR_Register({super.key});

  @override
  State<Login_OR_Register> createState() => _Login_OR_RegisterState();
}

class _Login_OR_RegisterState extends State<Login_OR_Register> {
  //initially  show login page
  bool showLoginPage = true;

  // toggle login and register
  void togglePage(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(onTap: togglePage,);
    }else{
      return RegisterPage(onTap: togglePage);
    }
  }
}
