import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late final  databaseProvider = Provider.of<DataBaseProvider>(context, listen: false);

  //user info
  UserProfile? user;
  String currentUserId = AuthService().getCurrentid();

  //loading...
   bool _isloading = true;

  @override
  void initState() {
    super.initState();

    //let load user info
    loadUser();
  }
  Future<void> loadUser() async{
    //get the user profile info
    user = await databaseProvider.userProfile(widget.uid);
    //finished loading...
    setState(() {
      _isloading = false;
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("P R O F I L E"),

      ),
      body: Center(
        child: Text(widget.uid),
      ),
    );
  }
}
