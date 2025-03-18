import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
}










