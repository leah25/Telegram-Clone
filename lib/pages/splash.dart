import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

import 'HomePage.dart';
import 'LoginPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateUser();
  }

  navigateUser() {
    return FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        Timer(
            Duration(seconds: 2),
            () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                })));
      } else {
        Timer(
            Duration(seconds: 2),
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                        currentUserId:
                            FirebaseAuth.instance.currentUser.uid))));
      }
    });
    // if (FirebaseAuth.instance.currentUser == null) {
    //   Timer(
    //       Duration(seconds: 2),
    //       () => Navigator.pushReplacement(context,
    //               MaterialPageRoute(builder: (context) {
    //             return LoginScreen();
    //           })));
    // } else {
    //   Timer(
    //       Duration(seconds: 2),
    //       () => Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => HomeScreen(
    //                   currentUserId: FirebaseAuth.instance.currentUser.uid))));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/playstore.png',
            width: 100,
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Sms_Chat',
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontStyle: FontStyle.italic,
                  fontSize: 30.0),
            ),
          ),
        ],
      )),
    );
  }
}
