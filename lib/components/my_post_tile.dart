import 'package:flutter/material.dart';

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
