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
      // Get current uid
      String uid = _auth.currentUser!.uid;

      // Use this uid to get the user profile
      UserProfile? user = await getUserFromFirebase(uid);

      /*if (user == null) {
        print("Error: User not found");
        return;
      }*/

      // Create a new post
      Post newPost = Post(
        id: '',
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likecount: 0,
        likedBy: [],
      );

      //convert post object -> map
      Map<String, dynamic> newPostMap = newPost.toMap();

      //add to firebase
      await _db.collection("Posts").add(newPostMap);

    }

    catch (e) {
      print("Error posting message: $e");
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
}










