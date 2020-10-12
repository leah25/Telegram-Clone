import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_chat_app/pages/HomePage.dart';
import 'package:sms_chat_app/widgets/ProgressWidget.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;

  bool isLoggedIn = false;
  bool isLoading = false;
  User currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isSignedIn() {}
  }

  Future<void> isSignedIn() async {
    this.setState(() {
      isLoggedIn = true;
    });

    preferences = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(currentUserId: preferences.getString('id'))));
    }
    this.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //
        //       colors: [Colors.lightBlueAccent, Colors.purpleAccent]),
        // ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sms_Chat',
              style: TextStyle(
                  fontSize: 64, color: Colors.white, fontFamily: 'Signatra'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: controlSignIn,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 270,
                      height: 45,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('images/google_signin_button.png'),
                        fit: BoxFit.cover,
                      )),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: isLoading ? circularProgress() : Container(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> controlSignIn() async {
    preferences = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuthentication =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken);

    User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    //Signin Success
    if (firebaseUser != null) {
      // Check if already Signup

      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .get();

      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;

      //final Map<String, dynamic> getDocs = documentSnapshots[0].data();

      // Save Data to firestore - if new user
      if (documentSnapshots.length == 0) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          "nickname": firebaseUser.displayName,
          "photoURL": firebaseUser.photoURL,
          "id": firebaseUser.uid,
          "aboutMe": " ",
          "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
          "chattingWith": null
        });

        //write data to Local
        currentUser = firebaseUser;
        await preferences.setString('id', currentUser.uid);
        await preferences.setString('nickname', currentUser.displayName);
        await preferences.setString('photoURL', currentUser.photoURL);
      } else {
        currentUser = firebaseUser;

        await preferences.setString('id', documentSnapshots[0].data()['id']);
        await preferences.setString(
            'nickname', documentSnapshots[0].data()['nickname']);
        await preferences.setString(
            'photoURL', documentSnapshots[0].data()['photoURL']);
        await preferences.setString(
            'aboutMe', documentSnapshots[0].data()['aboutMe']);
      }
      Fluttertoast.showToast(msg: 'Congratulations, Sign in Success');
      this.setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(currentUserId: firebaseUser.uid)));
    }
    //Signin not Success - Signin Failed
    else {
      Fluttertoast.showToast(msg: 'Try again, Sign in Failed.');
      this.setState(() {
        isLoading = false;
      });
    }
  }
}
