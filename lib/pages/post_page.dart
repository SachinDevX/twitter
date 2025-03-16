import 'package:flutter/material.dart';
import 'package:twitter/components/my_post_tile.dart';
import 'package:twitter/helper/navigate_pages.dart';

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
  @override
  Widget build(BuildContext context) {
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
              onPostTap: () {}
          ),
        ],
      ),
    );
  }
}
