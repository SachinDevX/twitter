import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/services/auth/auth_service.dart';
import 'package:twitter/services/database/database_provider.dart';

import '../models/post.dart';

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function() ? onUserTap;
  final void Function() ? onPostTap;
  
  const MyPostTile({
    super.key,
    required this.post,
    required this.onUserTap,
    required this.onPostTap,
  });

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {

  //provider
  late final listeningProvider = Provider.of<DataBaseProvider>(context);
  late final databaseProvider = Provider.of<DataBaseProvider>(context, listen: false);

  void _showOption() {
    //check if this post is owned by th user or not
    String currentUid = AuthService().getCurrentid();
    final bool isOwnPost = widget.post.uid == currentUid;

    showModalBottomSheet(
        context: context,
        builder: (context){
          return SafeArea(
            child: Wrap(
              children: [
                //this post belongs to current user
                if (isOwnPost)
                //delete message button
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete"),
                  onTap: () async {
                    //pop option box
                    Navigator.pop(context);

                    //handle delete action
                    await databaseProvider.deletePost(widget.post.id);
                  },
                )
                else ...[
                  //report post button
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text("Report"),
                    onTap: () {
                      //pop option box
                      Navigator.pop(context);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text("Block User"),
                    onTap: () {
                      //pop option box
                      Navigator.pop(context);
                    },
                  ),
                  ],
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Cancel"),
                  onTap: () {
                    //pop option box
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },

        );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        //padding outside
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),

        //padding outside
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          //color of post tile
          color: Theme.of(context).colorScheme.secondary,

          //curve corner
          borderRadius: BorderRadius.circular(8)
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          GestureDetector(
            onTap: widget.onUserTap,

            child: Row(
              children: [
                //profile pic
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(width: 10,),

                //name
                Text(
                    widget.post.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 4,),
                //username handle
                Text(
                  '@${widget.post.username}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                
                const Spacer(),
                
                //button -> more option: delete
                GestureDetector(
                  onTap: () => _showOption,
                  child:  Icon(Icons.more_horiz,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                //username handle
                Text(
                    widget.post.username,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ],
            ),
          ),

            const SizedBox(height: 20,),

            //message

            // message
            Text(
              widget.post.message,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ],
        ),
      ),
    );
  }
}
