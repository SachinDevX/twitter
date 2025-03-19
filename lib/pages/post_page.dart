import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/components/my_comment_tile.dart';
import 'package:twitter/components/my_post_tile.dart';
import 'package:twitter/helper/navigate_pages.dart';
import 'package:twitter/models/comments.dart';
import 'package:twitter/services/database/database_provider.dart';

import '../models/post.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({
    super.key,
    required this.post
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  //provider
  late final listeningProvider = Provider.of<DataBaseProvider>(context);
  late final databaseProvider =
      Provider.of<DataBaseProvider>(context, listen: false);
  @override
  Widget build(BuildContext context) {
    //listen to all comment for this post
    final allComments = listeningProvider.getComments(widget.post.id);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      //body
      body: ListView(
        children: [
          //post
          MyPostTile(
              post: widget.post,
              onUserTap: () => goUserPage(context, widget.post.uid),
              onPostTap: () {},
          ),
          //comment on this post
          allComments.isEmpty
          ?
              //NO comment yet..
          Center(
            child: Text("No comment yet"),
          )
              :
              //comment exits
          ListView.builder(
              itemCount: allComments.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context , index)
              {
            //get each comment
                final comment = allComments[index];

                //return as comment title ui
                return MyCommentTile(
                    comment: comment,
                    onUserTap: () => goUserPage(context, comment.uid),
                );

          },
          )

        ],
      ),
    );
  }
}
