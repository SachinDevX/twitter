import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/components/input_alert_box.dart';
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

  //on start up
  void initState() {
    super.initState();
    //load comments
    loadComments();
  }

  void _toggleLikePost() async {
    try{
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }
 //comment text controller
  final _commentController = TextEditingController();

//open comment box
  void _openNewCommentBox() {
    showDialog(
        context: context,
        builder: (context) => MyInputBox(
            hintText: "Type Comment",
            onPressed: () async {
              //add post in db
              await _addComment();
            },
            onPressedText: "Post",
            textcontroller: _commentController,
        ),
    );
  }

  //user tapped post to add comment
  Future<void> _addComment() async{
    //does nothing if there is nothing the text field
    if(_commentController.text.trim().isEmpty) return;

    //attempt to post comment
    try{
      await databaseProvider.addComment(widget.post.id, _commentController.text.trim());
    }catch (e){
      print(e);
    }
  }

  //load comment
  Future<void> loadComments() async {
    await databaseProvider.loadComments(widget.post.id);
  }

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

                      //handle report action
                      _reportPostConfirmationBox();
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text("Block User"),
                    onTap: () {
                      //pop option box
                      Navigator.pop(context);

                      //handle block action
                      _blockUserConfirmationBox();
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
  
  //report post confirmation
  void _reportPostConfirmationBox() {
    showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text("Report Message"),
          content: const Text("are you sure you want to report this message?"),
          actions: [
            //cancel button
            TextButton(onPressed: () => Navigator.pop(context), 
                child: const Text("Cancel "),
            ),
            
            
            //report button
            TextButton(
                onPressed: () async {
                  //close box
                  Navigator.pop(context);

                  //report user
                  await databaseProvider.reportUser(widget.post.id, widget.post.uid);
                  //let user know it was successfully reported
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Message reported!")));
                },
                child: const Text("Report"),
            )
          ],
        )
    );
  }


//block post confirmation
  void _blockUserConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Block User"),
          content: const Text("Are you sure you want to block this user?"),
          actions: [
            //cancel button
            TextButton(onPressed: () => Navigator.pop(context),
              child: const Text("Cancel "),
            ),


            //block button
            TextButton(
              onPressed: () async {
                //close box
                Navigator.pop(context);

                //report user
                await databaseProvider.blockUser( widget.post.uid);
                //let user know it was successfully block
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User blocked")));
              },
              child: const Text("Block"),
            )
          ],
        )
    );
  }
  @override


  Widget build(BuildContext context) {
    //does the current user like this post?
    bool likedByCurrentUser = listeningProvider.idPostLikedByCurrentUser(widget.post.id);


    //listen to like count
    int likeCount = listeningProvider.getLikeCount(widget.post.id) ?? widget.post.likecount;

    //listen to comment count
    int CommentCount = listeningProvider.getComments(widget.post.id).length;
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
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
                IconButton(
                  onPressed: _showOption,
                  icon: Icon(
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
              widget.post.message,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            
            const SizedBox(height: 20,),
            
            //button -> like + comment
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      //like button
                      GestureDetector(
                        onTap: _toggleLikePost,
                        child: likedByCurrentUser
                            ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                            : Icon(
                          Icons.favorite_border,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                //COMMENT SECTION
                Row(
                  children: [
                    //comment button
                    GestureDetector(
                      onTap: _openNewCommentBox,
                      child: Icon(Icons.comment,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 5,),

                    //comment count
                    Text(
                       CommentCount !=0 ? CommentCount.toString(): '',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 5,),
                //like count
                Text(
                  likeCount != 0 ? likeCount.toString() : '',
                style:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
