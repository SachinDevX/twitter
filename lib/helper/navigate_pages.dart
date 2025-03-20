import 'package:flutter/material.dart';
import 'package:twitter/pages/profile_page.dart';

import '../models/post.dart';
import '../pages/blocked_user_page.dart';
import '../pages/post_page.dart';

void goUserPage(BuildContext context, String uid) {
  //navigate to the page
  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(uid: uid)));
}

void goPostPage(BuildContext context, Post post ) {
  //navigate to post page
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostPage(post: post),
      ),
  );
}
//go to blocked user page
void goToBlockedUsersPage(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlockedUsersPage(),
    ),
  );
}