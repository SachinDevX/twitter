import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/user.dart';

class DataBaseService{
  //get instance of firestore db & auth
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  //save user info
Future<void> saveUserInfoFirebase({
    required String name,required String email}
    ) async{
  //get current uid
  String uid = auth.currentUser!.uid;

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
  await db.collection("User").doc(uid).set(userMap);
}
//get user info
Future<UserProfile?> getUserfromFirebase(String uid) async{
  try{
    //retrieve  user doc from firebase
    DocumentSnapshot userDoc = await db.collection("User").doc(uid).get();

    // convert doc to user profile
    return UserProfile.fromDocument(userDoc);
  }catch (e) {
    print (e);
    return null;
  }
}
}









