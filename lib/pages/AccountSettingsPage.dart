import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String id = '';
  String nickname = '';
  String photoURL = '';
  String aboutMe = '';
  File imageCircleAvatar;

  SharedPreferences preferences;

  bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateProfileSettings();
  }

  void getImage() async {
    PickedFile selectedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        imageCircleAvatar = File(selectedImage.path);
      });
    }
  }

  void updateProfileSettings() async {
    // getStored data from local
    preferences = await SharedPreferences.getInstance();

    id = preferences.getString('id');
    nickname = preferences.getString('nickname');
    photoURL = preferences.getString('photoURL');
    aboutMe = preferences.getString('aboutMe');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Account Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  child: Stack(
                    children: [
                      (imageCircleAvatar == null)
                          ? (photoURL != "")
                              ? Material(
                                  // will contain the image from the photoURL
                                  child: CachedNetworkImage(
                                    imageUrl: photoURL,
                                    placeholder: (context, url) {
                                      return Container(
                                        height: 200,
                                        width: 200,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.lightBlue),
                                        ),
                                      );
                                    },
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(120.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 200,
                                  color: Colors.grey,
                                )
                          : Material(
                              // display selected image
                              child: Image.file(
                                imageCircleAvatar,
                                height: 200,
                                width: 200,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(150.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                      Center(
                        child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.transparent,
                              size: 50.0,
                            ),
                            onPressed: getImage),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
