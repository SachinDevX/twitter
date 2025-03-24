import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter/services/database/database_services.dart';

class AuthService{
  //get instance of auth
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  //get current user and id
  User? getCurrentUser() => _auth.currentUser;
  String getCurrentid() => _auth.currentUser!.uid;

  //login ->email and pw
  Future<UserCredential> loginEmailPAssword(String email, password) async {
    //attempt login
    try{
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential;
    }
    on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }
  //register -> pw and email
  Future<UserCredential> registerEmailPassword(String email, password) async {
    //attempt to register new user
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential;
    }
    //catch any error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
//LOGOUT
  Future<void> logout() async {
    await _googleSignIn.signOut(); // Added Google sign-out here
    await _auth.signOut();
  }

//delete account
  Future<void> deleteAccount() async {
    //get current uid
    User? user = getCurrentUser();

    if(user != null) {
      //delete user data from fire store
      await DataBaseService().deleteUserInfoFromFirebase(user.uid);
      //delete the user auth record
      await user.delete();
    }
  }
  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  } // Fixed: Removed nested signOut() from here
}