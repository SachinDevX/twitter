import 'package:flutter/material.dart';
import 'package:twitter/components/my_drawer_tile.dart';
import 'package:twitter/services/auth/auth_service.dart';

import '../pages/Settings.dart';

class MyDrawer extends StatelessWidget {
   MyDrawer({super.key});

  //access auth_service
  final _auth = AuthService();

  //logout
   void logout() {
     _auth.logout();
   }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(  horizontal: 25.0),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
                ),
                Divider( color: Theme.of(context).colorScheme.secondary,),

                const SizedBox(height: 10),

                MyDrawerTile(
                  title: "H O M E",
                  icon: Icons.home,
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),

                MyDrawerTile(
                  title: "S E T T I N G S",
                  icon: Icons.person,
                  onTap: (){
                    Navigator.pop(context);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>SettingsPage()
                        ),
                    );
                  },
                ),
                const Spacer(),

                MyDrawerTile(
                    title: "LOG OUT",
                    icon: Icons.logout,
                    onTap: logout,
                ),

              ],
            ),
          )),
    );
  }
}
