import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/post.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/services/auth/auth_service.dart';
import 'package:twitter/services/database/database_services.dart';

class DataBaseProvider extends ChangeNotifier {
  final _auth = AuthService();
  final _db = DataBaseService();

  // Local list of posts
  List<Post> _allPost = [];

  // Getter for posts
  List<Post> get allPosts => _allPost;

  // Get user profile
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  // Update bio
  Future<void> updatebio(String bio) => _db.updateUserBIOFirebase(bio);

  // Post message
  Future<void> postMessage(String message) async {
    // Post message in firebase
    await _db.postMessageInFirebase(message);

    //reload data from firebase
    await loadAllPosts();
  }

  // Fetch all posts
  Future<void> loadAllPosts() async {
    // Get all posts from firebase
    final posts = await _db.getAllPostsFromFirebase();

    // Update local data
    _allPost = posts;

    // Update UI
    notifyListeners();
  }

//filter and return posts given uid
List<Post> filterUserPosts(String uid) {
    return _allPost.where((post) => post.uid == uid).toList();
}

}