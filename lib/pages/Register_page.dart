import 'package:flutter/material.dart';
import 'package:twitter/components/loading_circle.dart';
import 'package:twitter/services/auth/auth_service.dart';
import 'package:twitter/services/database/database_services.dart';

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
  //access auth and database service
  final _auth = AuthService();
  final _db = DataBaseService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPWController = TextEditingController();
  //register button tapped

  void register() async{
    //password matches -> create user
    if (pwController.text == confirmPWController.text){
      //show loading circle
      showLoadingCircle(context);

      //attempt to register new user
      try{
        //trying to register
        await _auth.registerEmailPassword(emailController.text, pwController.text);
        //finishing loading...
        if(mounted) hideLoadingCircle(context);

        //once register create and save user profile
        await _db.saveUserInfoFirebase(name: nameController.text, email: emailController.text);
      }
      catch(e){
        if(mounted) hideLoadingCircle(context);

        //let user know of the error
        if(mounted){
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(e.toString()
                ),
              ),
          );
        }
      }
    }
    //password does not match
    else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Password does not match "
          ),
        ),
      );
    }
  }
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

                MyButton(onTap: register,
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
