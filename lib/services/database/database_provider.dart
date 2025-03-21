import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/comments.dart';
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

  // Filter posts by user ID
  List<Post> filterUserPosts(String uid) {
    try {
      if (_allPost.isEmpty) return [];
      return _allPost.where((post) => post.uid == uid).toList();
    } catch (e) {
      print("Error filtering posts: $e");
      return [];
    }
  }

  // Get user profile
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  // Update bio
  Future<void> updatebio(String bio) => _db.updateUserBIOFirebase(bio);

  // Post message
  Future<void> postMessage(String message) async {
    // Post message in firebase
    await _db.postMessageInFirebase(message);
    // Reload posts after posting
    await loadAllPosts();
  }

  // Fetch all posts
  Future<void> loadAllPosts() async {
    try {
      // Get all posts from firebase
      final posts = await _db.getAllPostsFromFirebase();

      //get blocked user id
      final blockedUserIds = await _db.getBlockedUidsFromFirebase();

      //filter out blocked users posts and update locally
      _allPost =
          allPosts.where((post) => !blockedUserIds.contains(post.uid)).toList();

      // Update local data
      _allPost = posts;
      // Initialize like counts
      initializeLikeMap();
      // Update UI
      notifyListeners();
    } catch (e) {
      print("Error loading posts: $e");
    }
  }

  //delete post
  Future<void> deletePost(String postId) async {
    //delete from firebase
    await _db.deletePostFromFirebase(postId);

    //reload data from firebase
    await loadAllPosts();
  }

  //local map to track like counts for each post
  Map<String, int> _likeCounts = {
    //for each post id: like count
  };

  //local list to track posts liked by current user
  List<String> _likedPost = [];

  //does current user like this post ?
  bool idPostLikedByCurrentUser(String postId) => _likedPost.contains(postId);

  //get like count of a post
  int? getLikeCount(String postId) => _likeCounts[postId];

  //initialize like map locally
  void initializeLikeMap() {
    try {
      //get current uid
      final currentUserId = _auth.getCurrentid();

      //clear existing data
      _likedPost = [];
      _likeCounts = {};

      //for each post get like data
      for (var post in _allPost) {
        //update like count map
        _likeCounts[post.id] = post.likecount;

        //if the current user already likes this post
        if (post.likedBy.contains(currentUserId)) {
          //add this post id to local list of liked posts
          _likedPost.add(post.id);
        }
      }
      notifyListeners();
    } catch (e) {
      print("Error initializing like map: $e");
    }
  }

  Future<void> toggleLike(String postId) async {
    //store original values in case it fails
    final likedPostOriginal = _likedPost;
    final likeCountsOriginal = _likeCounts;

    //perform like / unlike
    if (_likedPost.contains(postId)) {
      _likedPost.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPost.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }

    //update UI locally
    notifyListeners();

    try {
      await _db.toggleLikeInFirebase(postId);

      //revert back to initial state if update fails
    } catch (e) {
      _likedPost = likedPostOriginal;
      _likeCounts = likeCountsOriginal;
    }
  }

  //local list of comment
  final Map<String, List<Comments>> _comments = {};

  //get comment locally
  List<Comments> getComments(String postId) => _comments[postId] ?? [];

//fetch comment from database for a post
  Future<void> loadComments(String postId) async {
    //get all the comment for this post
    final allComments = await _db.fetchCommentfromFirebase(postId);

    //update local data
    _comments[postId] = allComments;

    //update ui
    notifyListeners();
  }

//add a comment
  Future<void> addComment(String postId, message) async {
    //add comment in firebase
    await _db.AddCommentToFirebase(postId, message);

    //reload comments
    await loadComments(postId);
  }

//delete a comment
  Future<void> deleteComment(String commentId, postId) async {
    //delete comment in fire base
    await _db.deleteCommentInFirebase(commentId);
    //reload comment
    await loadComments(postId);
  }

  // Local list of blocked users
  List<UserProfile> _blockedUsers = [];

  // Getter for blocked users (fix the name)
  List<UserProfile> get blockedUsers => _blockedUsers;

  // Load blocked users (fix the name)
  Future<void> loadBlockedUsers() async {
    try {
      _blockedUsers = await _db.getBlockedUsersFromFirebase();
      notifyListeners();
    } catch (e) {
      print("Error loading blocked users: $e");
      _blockedUsers = [];
    }
  }

  // Block user
  Future<void> blockUser(String userId) async {
    await _db.blockUserInFirebase(userId);
    await loadBlockedUsers(); // Reload the list after blocking
  }

  // Unblock user
  Future<void> unblockUser(String userId) async {
    await _db.unblockUserInFirebase(userId);
    await loadBlockedUsers(); // Reload the list after unblocking
  }

  //report user and post
  Future<void> reportUser(String postId, userId) async {
    await _db.reportUserInFirebase(postId, userId);
  }

  //local map
  final Map<String, List<String>> _followers = {};
  final Map<String, List<String>> _following = {};
  final Map<String, int> _followersCount = {};
  final Map<String, int> _followingCount = {};

  //get counts for followers & following locally: given a uid
  int getFollowerCount(String uid) => _followersCount[uid] ?? 0;

  int getFollowingCount(String uid) => _followingCount[uid] ?? 0;

//load follower
  Future<void> loadUserFollowers(String uid) async {
    //get the list of follower uid from firebase
    final listOfFollowerUids = await _db.getFollowerUidsFormFirebase(uid);

    //update local data
    _followers[uid] = listOfFollowerUids;
    _followersCount[uid] = listOfFollowerUids.length;

    //update ui
    notifyListeners();
  }

  Future<void> loadUserFollowing(String uid) async {
    //get the list of follower uid from firebase
    final listOfFollowingUids = await _db.getFollowingUidsFormFirebase(uid);

    //update local data
    _followers[uid] = listOfFollowingUids;
    _followersCount[uid] = listOfFollowingUids.length;

    //update ui
    notifyListeners();
  }

  Future<void> followUser(String targetUserId) async {
    //get current uid
    final currentUserId = _auth.getCurrentid();

    //initialize with empty list if null
    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(currentUserId, () => []);

    //follow if current user is not one of the target user follower
    if (!_followers[targetUserId]!.contains(currentUserId)) {
      //add current user to target user follower list
      _followers[targetUserId]?.add(currentUserId);

      //update follower count
      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 0) + 1;

      //then add target user to current user following
      _following[currentUserId]?.add(targetUserId);

      //update following count
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;
    }
    //update ui
    notifyListeners();

    try {
      //follow user in firebase
      await _db.followUserInFirebase(targetUserId);

      //reload current users following
      await loadUserFollowing(currentUserId);
    }

    //if there is an error.. revert back to original
    catch (e) {
      //remove current user from target user follower
      _followers[targetUserId]?.remove(currentUserId);

      //update follower count
      _followingCount[targetUserId] = (_followersCount[targetUserId] ?? 0) - 1;

      //remove from current user following
      _following[currentUserId]?.remove(targetUserId);

      //update following count
      _followersCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) - 1;

      //update ui
      notifyListeners();
    }
  }

  Future<void> unfollowUser(String targetUserId) async {
    final currentUserId = _auth.getCurrentid();

    // initialize list if they don't exist
    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(currentUserId, () => []);

    // unfollow if current user is one of the target user's followers
    if (_followers[targetUserId]!.contains(currentUserId)) {
      // remove current user from target user following
      _followers[targetUserId]?.remove(currentUserId);

      // update follower count
      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 1) - 1;

      // remove target user from current user following list
      _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 1) - 1;
    }

    // update ui
    notifyListeners();
    
    try {
      // unfollow target user in firebase
      await _db.unFollowUserInFirebase(targetUserId);

      // reload user followers
      await loadUserFollowers(currentUserId);

      // reload user following
      await loadUserFollowing(currentUserId);
    } catch (e) {
      // if there is an error.. revert back to original
      // add current user back into target user follower
      _followers[targetUserId]?.add(currentUserId);

      // update follower count
      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 0) + 1;

      // add target user back into current user following list
      _following[currentUserId]?.add(targetUserId);

      // update following count
      _followingCount[currentUserId] = (_followingCount[targetUserId] ?? 0) + 1;

      // update ui
      notifyListeners();
    }
  }

  // Check if current user is following target user
  bool isFollowing(String targetUserId) {
    try {
      final currentUserId = _auth.getCurrentid();
      return _following[currentUserId]?.contains(targetUserId) ?? false;
    } catch (e) {
      print("Error checking following status: $e");
      return false;
    }
  }
}
















