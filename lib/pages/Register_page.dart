import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function() ? onTap;
  const RegisterPage({super.key,
  required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPWController = TextEditingController();

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
                //create account message
                const SizedBox(height: 50),
                Text("Let's Create Account for you",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                //email text field
                MyTextField(
                    controller: emailController,
                    hintText: "Enter email",
                    obscureText: false
                ),

                const SizedBox(height: 10),

                //name text field
                MyTextField(
                    controller: nameController,
                    hintText: "Enter Name",
                    obscureText: false
                ),

                const SizedBox(height: 10),
                //confirm password Text field
                MyTextField(
                    controller: confirmPWController,
                    hintText: "Confirm Password",
                    obscureText: true,
                ),
                const SizedBox(height: 10),

              // password text field
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
                    text: "Register"),

                const SizedBox(height: 50),
                //already a member ? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already a member?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 5),

                    //user can tap to go to Login page
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login",
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
