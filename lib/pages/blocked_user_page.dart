import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/services/database/database_provider.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  //provider
  late final listeningProvider = Provider.of<DataBaseProvider>(context);
  late final databaseProvider =
      Provider.of<DataBaseProvider>(context, listen: false);

  //on startup
  @override
  void initState() {
    super.initState();
    //load blocked users
    loadBlockedUsers();
  }
  Future<void> loadBlockedUsers() async {
    await databaseProvider.loadBlockedUsers();
  }

  //show confirm unblock user
  void _showUnblockBox(String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Unblock User"),
          content: const Text("Are you sure you want to unblock this user?"),
          actions: [
            //cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            //unblock button
            TextButton(
              onPressed: () async {
                //close box
                Navigator.pop(context);

                //unblock user
                await databaseProvider.unblockUser(userId);
                //let user know it was successfully reported
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User Unblocked!")));
                }
              },
              child: const Text("Unblock"),
            )
          ],
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    //listen to blocked users
    final blockedUsers = listeningProvider.blockedUsers;
    //SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        title: const Text("Blocked Users"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      //Body
      body: blockedUsers.isEmpty
      ? Center(
        child: Text("No blocked users..", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      )
      : ListView.builder(
          itemCount: blockedUsers.length,
          itemBuilder: (context, index) {
            //get each user
            final user = blockedUsers[index];
            
            //return as a listTile Ui
            return ListTile(
              title: Text(user.name),
              subtitle: Text('@${user.username}'),
              trailing: IconButton(
                  onPressed: () => _showUnblockBox(user.uid),
                  icon: const Icon(Icons.block)
              ),
            );
          }
      )    
    );
  }
}










