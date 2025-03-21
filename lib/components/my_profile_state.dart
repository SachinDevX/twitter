import 'package:flutter/material.dart';

class MyProfileState extends StatelessWidget {
  final int postCount;
  final int follwerCount;
  final int followingCount;
  final void Function()? onTap;
  const MyProfileState({
    super.key,
    required this.postCount,
    required this.followingCount,
    required this.follwerCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    //textstyle for count
    var textStyleForCount = TextStyle(
      fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary
    );
    var textStyleForText = TextStyle(
         color: Theme.of(context).colorScheme.primary
    );
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //post
          SizedBox(
            width: 100,
            child: Column(
                  children: [
                    Text(
                        postCount.toString(),
                      style: textStyleForCount,
                    ), 
                    Text("Posts",
                    style: textStyleForText,
                    )
                  ],
                ),
          ),
      
          //follower
          SizedBox(
            width: 100,
            child: Column(
              children: [Text(follwerCount.toString()), Text("Posts")],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followingCount.toString(),
                  style: textStyleForCount,
                ),
                Text("Following",
                style: textStyleForText,
                )],
            ),
          ),
          ],
      ),
    );
  }
}
