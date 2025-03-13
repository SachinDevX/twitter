import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfile{
  final String uid;
  final String bio;
  final String email;
  final String username;
  final String name;

  UserProfile({
    required this.uid,
    required this.bio,
    required this.email,
    required this.username,
    required this.name,
});
  //convert firestore document to a user profile (so that we can use in our app)
factory UserProfile.fromDocument(DocumentSnapshot doc ) {
  return UserProfile(
      uid: doc['uid'],
      bio: doc['bio'],
      email: doc['email'],
      username: doc['username'],
      name: doc['name'],
  );

    }
    //convert a user profile to a map (so we can store in firebase)
  Map<String,dynamic> tomap(){
  return {
    'uid': uid,
    'name': name,
    'email':email,
    'username':username,
    'bio': bio,
  };
  }
}








