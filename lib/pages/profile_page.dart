import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/components/bio_box.dart';
import 'package:twitter/components/input_alert_box.dart';
import 'package:twitter/components/my_post_tile.dart';
import 'package:twitter/helper/navigate_pages.dart';
import 'package:twitter/models/user.dart';
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
