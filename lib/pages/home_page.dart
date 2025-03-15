import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/components/input_alert_box.dart';
import 'package:twitter/components/my_drawer.dart';
import 'package:twitter/services/database/database_provider.dart';

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

  // on startup
  @override
  void initState() {
    super.initState();

    //let load all the post
    loadAllPosts();
  }

  //load all posts
  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }
  //show post message dialog box
  void _openPostMessageBoX() {
    showDialog(
        context: context,
        builder: (context) => MyInputBox(
            hintText: "What on your mind?",
            onPressed: () async {
              //post in db
              await postMessage(_messageController.text);
            },
            onPressedText: "Post",
            textcontroller: _messageController
        ),
    );
  }
  //user wants to post message
  Future<void> postMessage(String message ) async {
    await databaseProvider.postMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer:  MyDrawer(),
      appBar: AppBar(
        title: const Text("H O M E"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      
      //floatingAction
      floatingActionButton: FloatingActionButton(
          onPressed: _openPostMessageBoX,
        child: const  Icon(Icons.add),
      ),

      //Body: list of all post
      body: _buildPostList(listeningProvider.allPosts),
    );
  }

  //build list UI given a list of posts
Widget _buildPostList(List<Post> posts) {
    return posts.isEmpty
        ?

        //post list is empty
  const Center(
    child: Text("Nothing here.."),
  )
        :
   //post list is not empty
  ListView.builder(
    itemCount: posts.length,
      itemBuilder: (context, index) {
      //get each individual post
        final post = posts[index];

        //return post title ui
        return Container(
          child: Text(post.message),
        );
      }
  )
}
}















