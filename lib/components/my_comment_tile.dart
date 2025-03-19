import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/services/database/database_provider.dart';

import '../models/comments.dart';
import '../services/auth/auth_service.dart';



class MyCommentTile extends StatelessWidget {
  final Comments comment;
  final void Function()? onUserTap;
  const MyCommentTile({super.key,
  required this.comment,
    required this.onUserTap
  });


  void _showOption(BuildContext context) {
    //check if this post is owned by th user or not
    String currentUid = AuthService().getCurrentid();
    final bool isOwnComment = comment.uid == currentUid;

    showModalBottomSheet(
      context: context,
      builder: (context){
        return SafeArea(
          child: Wrap(
            children: [
              //this post belongs to current user
              if (isOwnComment)
              //delete message button
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete"),
                  onTap: () async {
                    //pop option box
                    Navigator.pop(context);

                    //handle delete action
                    await Provider.of<DataBaseProvider>(context)
                    .deleteComment(comment.id, comment.postId);
                  },
                )
              else ...[
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
              //cancel button
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
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
                  comment.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 4,),
                //username handle
                Text(
                  '@${comment.username}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const Spacer(),

                //button -> more option: delete
                GestureDetector(
                  onTap: () => _showOption(context),
                  child:  Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

              ],
            ),
          ),

          const SizedBox(height: 20,),

          //message

          // message
          Text(
            comment.message,
            style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary),
          ),

          const SizedBox(height: 20,),

          //button -> like + comment

        ],
      ),
    );
  }
}
