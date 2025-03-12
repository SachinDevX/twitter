import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  //get instance of auth
    final _auth = FirebaseAuth.instance;

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

}













