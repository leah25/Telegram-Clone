import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String nickname;
  final String photoUrl;
  final String createdAt;

  User({
    this.id,
    this.nickname,
    this.photoUrl,
    this.createdAt,
  });

  factory User.fromDocument(DocumentSnapshot data) {
    Map getDocs = data.data();
    return User(
      // ignore: deprecated_member_use
      id: data.documentID,
      photoUrl: getDocs['photoUrl'],
      nickname: getDocs['nickname'],
      createdAt: getDocs['createdAt'],
    );
  }
}
