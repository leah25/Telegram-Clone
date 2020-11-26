import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_chat_app/pages/ChattingPage.dart';

class CurrentChats extends StatefulWidget {
  final String receiverId;
  final String receiverPhoto;
  final String receiverName;

  CurrentChats({this.receiverName, this.receiverPhoto, this.receiverId});
  @override
  _CurrentChatsState createState() => _CurrentChatsState();
}

class _CurrentChatsState extends State<CurrentChats> {
  String chatId;
  SharedPreferences preferences;
  String id;
  var listMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLocal();
  }

  readLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id') ?? "";

    if (id.hashCode <= widget.receiverId.hashCode) {
      chatId = '$id-${widget.receiverId}';
    } else {
      chatId = '${widget.receiverId}-$id';
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection(chatId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(' Select Contact',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26.0)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              receiverPhoto: document.data()['photoURL'],
                              receiverName: document.data()['nickname'],
                              receiverId: document.data()['id'])));
                },
                child: new ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: CachedNetworkImageProvider(
                          document.data()['photoURL']),
                    ),
                    title: Text(
                      document.data()['nickname'],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${document.data()['content']}'),
                    trailing: IconButton(
                        icon:
                            Icon(Icons.message, size: 25.0, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      receiverPhoto:
                                          document.data()['photoURL'],
                                      receiverName: document.data()['nickname'],
                                      receiverId: document.data()['id'])));
                        })),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
