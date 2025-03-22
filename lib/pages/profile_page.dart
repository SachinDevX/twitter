import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/components/bio_box.dart';
import 'package:twitter/components/input_alert_box.dart';
import 'package:twitter/components/my_follow_button.dart';
import 'package:twitter/components/my_post_tile.dart';
import 'package:twitter/components/my_profile_state.dart';
import 'package:twitter/helper/navigate_pages.dart';
import 'package:twitter/models/user.dart';
//import 'package:twitter/pages/follow_list_page.dart';
import 'package:twitter/services/auth/auth_service.dart';
import 'package:twitter/services/database/database_provider.dart';

class ProfilePage extends StatefulWidget {
  //user id
  final String uid;
  const ProfilePage({
    super.key,
    required this.uid
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //provider
  late final listeningProvider = Provider.of<DataBaseProvider>(context);
  late final  databaseProvider = Provider.of<DataBaseProvider>(context, listen: false);

  //user info
  UserProfile? user;
  String currentUserId = AuthService().getCurrentid();

  //text controller for bio
  final bioTextController = TextEditingController();

  //loading...
   bool _isloading = true;

   //isFollowing State
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    // Load both user info and posts
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      setState(() {
        _isloading = true;
      });
      
      // Load user profile
      user = await databaseProvider.userProfile(widget.uid);

      // Load follower and following for this user
      await databaseProvider.loadUserFollowers(widget.uid);
      await databaseProvider.loadUserFollowing(widget.uid);

      // Update following state
      setState(() {
        _isFollowing = databaseProvider.isFollowing(widget.uid);
      });
      
      // Load posts
      await databaseProvider.loadAllPosts();
      
      if (user == null) {
        print("Could not load user with ID: ${widget.uid}");
      }
    } catch (e) {
      print("Error loading initial data: $e");
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  //show edit bio box
  void _showEditBioBox(){
    showDialog(context: context,
        builder: (context) => MyInputBox(
            hintText: "Edit Bio...",
            onPressed: saveBio,
            onPressedText: "Save",
            textcontroller: bioTextController,
        ));
  }

  //toggle follow / unfollow
Future<void> toggleFollow() async {
  if (_isloading) return; // Prevent multiple calls while loading

  try {
    setState(() => _isloading = true);

    if (_isFollowing) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Unfollow"),
          content: const Text("Are you sure you want to unfollow?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await databaseProvider.unfollowUser(widget.uid);
                  if (mounted) {
                    setState(() {
                      _isFollowing = false;
                    });
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to unfollow user"))
                    );
                  }
                }
              },
              child: const Text("Yes"),
            )
          ],
        )
      );
    } else {
      try {
        await databaseProvider.followUser(widget.uid);
        if (mounted) {
          setState(() {
            _isFollowing = true;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to follow user"))
          );
        }
      }
    }
  } finally {
    if (mounted) {
      setState(() => _isloading = false);
    }
  }
}

//save updated bio
  Future<void> saveBio() async {
    //start loading
    setState(() {
      _isloading = true;
    });

    //update bio
    await databaseProvider.updatebio(bioTextController.text);

    //reload user
    await loadInitialData();

    //done loading
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get filtered posts for this user
    final allUserPosts = listeningProvider.filterUserPosts(widget.uid);

    //listen to followers and following count
    final followerCount = listeningProvider.getFollowerCount(widget.uid);
    final followingCount = listeningProvider.getFollowingCount(widget.uid);


    //listen to is following
    _isFollowing = listeningProvider.isFollowing(widget.uid);
    // Show loading indicator while data is being fetched
    if (_isloading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("Loading..."),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show error state if user is null
    if (user == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("Error"),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: const Center(
          child: Text("Could not load user profile"),
        ),
      );
    }

    // Show actual profile when data is loaded
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          Center(
            child: Text(
              '@${user!.username}',  // Changed from name to username
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),

          const SizedBox(height: 25),
          
          // Profile icon
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(25),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ),

          const SizedBox(height: 25,),

          //profile stats -> number of posts / follower / following
          MyProfileState(
            postCount: allUserPosts.length,
            followingCount: followingCount,
            followerCount: followerCount,
            onTap: () {}
          ),

          const SizedBox(height: 25,),

          //follow/ unfollow button
          //only show id the user is viewing someone else profile
          if(user != null && user!.uid != currentUserId)
            MyFollowButton(
                onPressed: toggleFollow,
                isFollowing: _isFollowing),



          // Bio section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bio",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                // Only show edit button if it's the current user's profile
                if (widget.uid == currentUserId)
                  GestureDetector(
                    onTap: _showEditBioBox,
                    child: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          
          // Bio box
          MyBioBox(
            text: user!.bio
          ),

          const SizedBox(height: 10),

          // Posts section
          if (allUserPosts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  "No posts yet..",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            )
          else
            ListView.builder(
              itemCount: allUserPosts.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final post = allUserPosts[index];
                return MyPostTile(
                  post: post,
                  onUserTap: () {},
                  onPostTap: () => goPostPage(context, post),
                );
              }
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    bioTextController.dispose();
    super.dispose();
  }
}
