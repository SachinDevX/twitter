
import 'package:cloud_firestore/cloud_firestore.dart';

class Comments{
  final String uid;
  final String postId;
  final String id;
  final String name;
  final String username;
  final String message;
  final Timestamp timestamp;

Comments({
  required this.id,
  required this.postId,
  required this.uid,
  required this.name,
  required this.username,
  required this.message,
  required this.timestamp,

});

//convert fire store data into a comment object (to use in our app)
factory Comments.fromDocument(DocumentSnapshot doc) {
  return Comments(
      id: doc.id,
      postId: doc['postId'],
      uid: doc['uid'],
      name: doc['name'],
      username: doc['username'],
      message: doc['message'],
      timestamp: doc['timestamp']
    );

}

Map<String , dynamic> toMap() {
  return{
    'postId' : postId,
    'uid': uid,
    'name': name,
    'username': username,
    'message': message,
    'timestamp':timestamp
  };
}
}