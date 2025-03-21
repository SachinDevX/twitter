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
    loadPosts();
  }

  Future<void> loadPosts() async {
    await databaseProvider.loadAllPosts();
  }

  Future<void> _handleRefresh() async {
    try {
      await loadPosts();
    } catch (e) {
      print("Error refreshing: $e");
    }
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _openPostMessageBoX,
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 4,
          highlightElevation: 8,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.edit,
                size: 28,
                color: Theme.of(context).colorScheme.surface,
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Icon(
                  Icons.add,
                  size: 16,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        color: Theme.of(context).colorScheme.primary,
        child: posts.isEmpty
            ? ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: Text(
                        "Nothing here..",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
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
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}















