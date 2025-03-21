import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/comments.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/services/auth/auth_service.dart';

import '../../models/post.dart';

class DataBaseService{
  //get instance of firestore db & auth
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //save user info
Future<void> saveUserInfoFirebase({
    required String name,required String email}
    ) async{
  //get current uid
  String uid = _auth.currentUser!.uid;

  //extract username from email
  String username = email.split('@') [0];

  //create a user profile
  UserProfile user = UserProfile(
      uid: uid,
      bio: '',
      email: email,
      username: username,
      name: name,
  );
  //convert user info a map so that we can store in firebase
  final userMap = user.tomap();

  //save user info in firebase
  await _db.collection("User").doc(uid).set(userMap);
}
//get user info
Future<UserProfile?> getUserFromFirebase(String uid) async{
  try{
    //retrieve  user doc from firebase
    DocumentSnapshot userDoc = await _db.collection("User").doc(uid).get();

    if (!userDoc.exists) {
      print("No user document found for uid: $uid");
      return null;
    }

    // convert doc to user profile
    return UserProfile.fromDocument(userDoc);
  }catch (e) {
    print("Error fetching user: $e");
    return null;
  }
}
//update user bio
Future<void> updateUserBIOFirebase(String bio) async{
  //get current uid
  String uid = _auth.currentUser?.uid ?? '';

  //attempt to update in firebase
  try{
    await _db.collection("User").doc(uid).update({'bio': bio});
  }catch(e){
    print("Error updating bio: $e");
  }
}

//delete user info
  Future<void> deleteUserInfoFromFirebase(String uid) async{
  WriteBatch batch = _db.batch();

  //delete user doc
    DocumentReference userDoc = _db.collection("User").doc(uid);
    batch.delete(userDoc);

    //delete user posts
    QuerySnapshot userPosts =
        await _db.collection("Posts").where('uid', isEqualTo: uid).get();

    for (var post in userPosts.docs) {
      batch.delete(post.reference);
    }

    //delete liked don by this user
  QuerySnapshot allPosts = await _db.collection("Posts").get();
    for (QueryDocumentSnapshot post in allPosts.docs) {
      Map<String, dynamic> postData = post.data() as Map<String, dynamic>;
      var likedBy = postData['likedBy '] as List<dynamic>? ?? [];

      if(likedBy.contains(uid)) {
        batch.update(post.reference, {
          'likedBy ': FieldValue.arrayRemove([uid]),
          'likes' : FieldValue.increment(-1),
        });
      }
    }
  QuerySnapshot userComments =
  await _db.collection("Comments").where('uid', isEqualTo: uid).get();

  for (var comment in userComments.docs) {
    batch.delete(comment.reference);
  }
  }

Future<void> postMessageInFirebase(String message) async {
  try {
    String uid = _auth.currentUser!.uid;
    UserProfile? user = await getUserFromFirebase(uid);

    if (user == null) {
      print("Error: User not found");
      return;
    }

    Post newPost = Post(
      id: '',
      uid: uid,
      name: user.name,
      username: user.username,
      message: message,
      timestamp: Timestamp.now(),
      likecount: 0,
      likedBy: [],
    );

    await _db.collection("Posts").add(newPost.toMap());
    print("Post added successfully"); // Add this for debugging
  } catch (e) {
    print("Error posting message: $e");
  }
}

Future<void> deletePostFromFirebase(String postId) async {
  try{
    await _db.collection("Posts").doc(postId).delete();
  }catch (e){
    print(e);
  }
}





  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Posts")
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      print("Error getting all posts: $e");
      return [];
    }
  }

  Future<void> toggleLikeInFirebase(String postId) async{
    try{
      //get current uid
      String uid = _auth.currentUser!.uid;

      //go to odc for this post
      DocumentReference postDoc = _db.collection("Posts").doc(postId);

      //execute like
      await _db.runTransaction((transaction) async{
        //get post data
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);

        //get like of users who lik this post
        List<String> likedBy =
            List<String>.from(postSnapshot['likedBY'] ?? []);

        //get like count
        int currentLikeCount = postSnapshot['likes'];

        //if usr has not liked this post yet -> then like
        if (!likedBy.contains(uid)){
          //add user to like list
          likedBy.add(uid);

          //increment like count
          currentLikeCount++;
        }

        //update in firebase
        transaction.update(postDoc,{
          'likes': currentLikeCount,
          'likedBy': likedBy,
        },
        );
        },
      );
    }catch (e) {
      print(e);
    }
  }
  //add comment to the firebase
  Future<void> AddCommentToFirebase(String postId , message) async {
  try{
    //get current user
    String uid = _auth.currentUser!.uid;
    UserProfile? user = await getUserFromFirebase(uid);

    //create a new comment
    Comments newComment = Comments(
      id: '',//auto generated by firebase
        postId : postId,
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp:Timestamp.now(),

    );

    //convert map to comment
    Map<String, dynamic> newCommentMap = newComment.toMap();

    //to store in fire base
    await _db.collection("comments").add(newCommentMap);
  }catch(e){
    print(e);
  }
  }
  Future<void> deleteCommentInFirebase(String commentId) async {
    try{
      await _db.collection("comments").doc(commentId).delete();

    }catch (e){
      print(e);
    }
  }

  //fetch comment from the post
Future<List<Comments>> fetchCommentfromFirebase(String postId) async{
  try{
    //get comment from fire base
    QuerySnapshot snapshot = await _db
        .collection("comments")
        .where("postId ", isEqualTo: postId)
        .get();
    //return list of comment
    return snapshot.docs.map((doc) => Comments.fromDocument(doc)).toList();

  }catch (e) {
    print(e);
    return [];
  }
}

Future<void> reportUserInFirebase(String postId, userId) async {
  //get current user id
  final currentUserId = _auth.currentUser!.uid;

  //create a report map
  final report = {
    'reportedBy': currentUserId,
    'messageId': postId,
    'messageOwnerId': userId,
    'timestamp' : FieldValue.serverTimestamp(),
  };
  //update in firebase
  await _db.collection("Reports").add(report);
}
//block user
Future<void> blockUserInFirebase(String useeId ) async{
  //get current user id
  final currentUSerId = _auth.currentUser!.uid;

  //add this user to blocked list
  await _db
  .collection("user")
  .doc(currentUSerId)
  .collection("BLockedUser")
  .doc(useeId)
  .set({});
}
//unblock user
Future<void> unblockUserInFirebase(String blockUserId) async{
  //get current user id
  final currentUserId = _auth.currentUser!.uid;

  //unblock in firebase
  await _db
  .collection("User")
  .doc(currentUserId)
  .collection("blocked User")
  .doc(blockUserId)
  .delete();
}
//Get list of blocked user ids
Future<List<String>> getBlockedUidsFromFirebase() async {
  //get current user id
  final currentUserId = _auth.currentUser!.uid;
  
  //get data of blocked user
  final snapshot = await _db
      .collection("User")
      .doc(currentUserId)
      .collection("blocked User")
      .get();
  
  //return as a list of uids
  return snapshot.docs.map((doc) => doc.id).toList();
}
}










