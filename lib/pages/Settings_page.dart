import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/components/settings_tile.dart';
import 'package:twitter/themes/theme_provider.dart';
import 'package:twitter/services/database/database_provider.dart';

import '../helper/navigate_pages.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Load blocked users when page opens
    Provider.of<DataBaseProvider>(context, listen: false).loadBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // Dark mode switch
          ListTile(
            title: const Text("DARK MODE"),
            trailing: CupertinoSwitch(
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) => 
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            ),
          ),

          // Blocked Users Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Blocked Users",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          // List of blocked users
          Consumer<DataBaseProvider>(
            builder: (context, provider, child) {
              final blockedUsers = provider.blockedUsers;
              
              if (blockedUsers.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No blocked users"),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: blockedUsers.length,
                  itemBuilder: (context, index) {
                    final user = blockedUsers[index];
                    return ListTile(
                      leading: const Icon(Icons.block),
                      title: Text(user.name),
                      subtitle: Text('@${user.username}'),
                      trailing: TextButton(
                        onPressed: () => provider.unblockUser(user.uid),
                        child: const Text("Unblock"),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
