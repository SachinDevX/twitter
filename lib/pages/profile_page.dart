import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/components/bio_box.dart';
import 'package:twitter/components/input_alert_box.dart';
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

  //text controller for bio
  final bioTextController = TextEditingController();

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
    await loadUser();

    //done loading
    setState(() {
      _isloading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(_isloading ? '': user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            Center(
              child: Text(_isloading ? '': '@${user!.name}',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),

            ),

            const SizedBox(height: 25,),
            Center(
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(25),
              ),
                padding: const  EdgeInsets.all(25),
                child:  Icon(Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
                ),
              )
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bio",
                style:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: _showEditBioBox,
                  child: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
          MyBioBox(
              text: _isloading ? '...' : user!.bio
          ),
          ]
        ),
      ),
    );
  }
}
