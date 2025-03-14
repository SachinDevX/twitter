import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/services/auth/auth_service.dart';

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
Future<UserProfile?> getUserfromFirebase(String uid) async{
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
}









