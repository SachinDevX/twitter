import 'package:flutter/material.dart';
import 'package:twitter/services/auth/auth_service.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({super.key});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  //ask for confirmation from the user before deleting their account
   void confirmDeletion(BuildContext context) {
     showDialog(
         context: context,
         builder: (context) => AlertDialog(
           title: const Text(" Delete"),
           content: const Text("are you sure you want to delete this account?"),
           actions: [
             //cancel button
             TextButton(onPressed: () => Navigator.pop(context),
               child: const Text("Cancel "),
             ),


             //delete button
             TextButton(
               onPressed: () async {
                 //close box
                 Navigator.pop(context);

                 //delete user
                 await AuthService().deleteAccount();

                 //then navigate to initial route (Auth gate -> login/registration
                  Navigator.pushNamedAndRemoveUntil(context,
                      '/',
                      (route) => false,
                  );
               },
               child: const Text("Deleted"),
             )
           ],
         )
     );
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Setting Page'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      
      //body
      body: Column(
        children: [
          //delete tile
          GestureDetector(
            onTap: () => confirmDeletion(context),
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text("delete account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              )
            ),
          )
        ],
      ),
    );
  }
}
