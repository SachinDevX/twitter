import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/components/settings_tile.dart';
import 'package:twitter/themes/theme_provider.dart';

import '../helper/navigate_pages.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        title: Text('Settings Page'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          MySettingsTile(title: "DARK MODE",
              action: CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              ),
          ),

          //Block user tile
          MySettingsTile(
              title: "Blocked User",
              action: GestureDetector(
                onTap: () =>  goToBlockedUsersPage(context),
                child: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
          )
        ],
      ),

    );
  }
}
