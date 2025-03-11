import 'package:flutter/material.dart';
import 'package:twitter/components/my_button.dart';
import 'package:twitter/components/my_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body:   Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 50),
                Icon(Icons.lock_open_rounded,
                size: 72,
                color: Theme.of(context).colorScheme.primary),

                const SizedBox(height: 50),
                Text("Welcome back , you\ ve missed",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),

                MyTextField(
                    controller: emailController,
                    hintText: "Enter email",
                    obscureText: false
                ),
                const SizedBox(height: 10),
                MyTextField(
                    controller: pwController,
                    hintText: "Enter Password",
                    obscureText: true
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                
                MyButton(onTap: () {},
                    text: "Login"),

                const SizedBox(height: 50),
                //not a member ? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                    "Not a member?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ),
                    const SizedBox(width: 5),
                    //user can tap to go to register page
                    GestureDetector(
                      onTap: (){},
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

