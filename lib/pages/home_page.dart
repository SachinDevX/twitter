import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/components/input_alert_box.dart';
import 'package:twitter/components/my_drawer.dart';
import 'package:twitter/components/my_post_tile.dart';
import 'package:twitter/helper/navigate_pages.dart';
import 'package:twitter/services/database/database_provider.dart';

import '../models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //provider
  late final databaseProvider = Provider.of<DataBaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DataBaseProvider>(context);

  //text controller
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load posts when page initializes
    loadAllPosts();
  }

  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }

  void _openPostMessageBoX() {
    showDialog(
      context: context,
      builder: (context) => MyInputBox(
        hintText: "What's on your mind?",
        onPressed: () async {
          if (_messageController.text.isNotEmpty) {
            // Post message
            await databaseProvider.postMessage(_messageController.text);
            
            // Clear the text controller
            _messageController.clear();
            
            // Close the dialog
            if (context.mounted) Navigator.pop(context);
          }
        },
        onPressedText: "Post",
        textcontroller: _messageController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get posts from provider
    final posts = listeningProvider.allPosts;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text("H O M E"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostMessageBoX,
        child: const Icon(Icons.add),
      ),
      body: posts.isEmpty
          ? const Center(
              child: Text("Nothing here.."),
            )
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return MyPostTile(post: post,
                onUserTap: () => goUserPage(context, post.uid),
                  onPostTap: () => goPostPage(context, post),

                );
              },
            ),
    );
  }
}















