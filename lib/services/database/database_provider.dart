import 'package:flutter/material.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/services/auth/auth_service.dart';
import 'package:twitter/services/database/database.dart';

class DataBaseProvider extends ChangeNotifier{
  final _auth = AuthService();
  final _db = DataBaseService();

  Future<UserProfile?> userProfile(String uid) => _db.getUserfromFirebase(uid);
}