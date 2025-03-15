import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post{
  final String id;
  final String uid;
  final String name;
  final String username;
  final String message;
  final Timestamp timestamp;
  final int likecount;
  final List<String> likedBy;

  Post({
    required this.timestamp,
    required this.id,
    required this.username,
    required this.name,
    required this.message,
    required this.likecount,
    required this.likedBy,
    required this.uid
});

  //convert a Firestore document to a post object(to use in our app)
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      uid: doc['uid'],
      name: doc['name'],
      username: doc['username'],
      message: doc['message'],
      timestamp: doc['timestamp'],
      likecount: doc['likes'],
      likedBy:List<String>.from(doc['likedBY'] ?? []),
    );
  }
  //convert a post object to a map (to store in Firebase)
Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp,
      'likes': likecount,
      'likedBy': likedBy
    };
}






}