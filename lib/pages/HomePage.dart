import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sms_chat_app/main.dart';
import 'package:sms_chat_app/pages/AccountSettingsPage.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  HomeScreen({this.currentUserId});

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  clearText() {
   searchController.clear();
  }

  homePageHeader() {
    return AppBar(
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            })
      ],
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search here',
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          disabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          prefixIcon: IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: null),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: clearText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageHeader(),
      body: Center(
        child: RaisedButton.icon(
            onPressed: signingOut,
            icon: Icon(Icons.exit_to_app),
            label: Text('Logout')),
      ),
    );
  }

  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> signingOut() async {
    auth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}
