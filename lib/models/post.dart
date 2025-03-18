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
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Post(
      id: doc.id,
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      likecount: data['likecount'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
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
      'likecount': likecount,
      'likedBy': likedBy
    };
}






}