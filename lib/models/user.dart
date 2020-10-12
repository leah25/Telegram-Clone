import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String nickname;
  final String photoURL;
  final String createdAt;

  User({
    this.id,
    this.nickname,
    this.photoURL,
    this.createdAt,
  });

  factory User.fromDocument(DocumentSnapshot data) {
    Map getDocs = data.data();
    return User(
      // ignore: deprecated_member_use
      id: data.documentID,
      photoURL: getDocs['photoURL'],
      nickname: getDocs['nickname'],
      createdAt: getDocs['createdAt'],
    );
  }
}
