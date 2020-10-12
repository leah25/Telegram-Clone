import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sms_chat_app/models/user.dart';
import 'package:sms_chat_app/pages/AccountSettingsPage.dart';
import 'package:sms_chat_app/pages/ChattingPage.dart';
import 'package:sms_chat_app/widgets/ProgressWidget.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  HomeScreen({this.currentUserId});

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchedSnapshot;

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
        onFieldSubmitted: searchInputText,
      ),
    );
  }

  searchInputText(String searchName) {
    Future<QuerySnapshot> allUsers = FirebaseFirestore.instance
        .collection("users")
        .where("nickname", isGreaterThanOrEqualTo: searchName)
        .get();

    setState(() {
      searchedSnapshot = allUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageHeader(),
      body: (searchedSnapshot == null) ? HasNoDataScreen() : HasDataScreen(),
    );
  }

  HasDataScreen() {
    return FutureBuilder(
      future: searchedSnapshot,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchUserResult = [];
        dataSnapshot.data.documents.forEach((document) {
          if (document != null) {
            User eachUser = User.fromDocument(document);
            UserResult userResult = UserResult(eachUser: eachUser);
            if (widget.currentUserId != document.data()['id']) {
              searchUserResult.add(userResult);
            }
          } else {
            return Fluttertoast.showToast(msg: 'User not Found!');
          }
        });
        return ListView(
          children: searchUserResult,
        );
      },
    );
  }

  HasNoDataScreen() {
    return Container(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 30.0,
              ),
              Icon(
                Icons.group,
                size: 200,
                color: Colors.blue,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Search Users',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult({this.eachUser});

  @override
  Widget build(BuildContext context) {
    navigateToChat() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                  receiverPhoto: eachUser.photoURL,
                  receiverName: eachUser.nickname,
                  receiverId: eachUser.id)));
    }

    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          return navigateToChat();
        },
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage:
                        CachedNetworkImageProvider(eachUser.photoURL),
                  ),
                  title: Text(
                    eachUser.nickname,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Joined:' +
                        DateFormat('dd MMMM yyyy - hh:mm:aa').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(eachUser.createdAt))),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
