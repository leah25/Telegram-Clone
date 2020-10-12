import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPhotoScreen extends StatefulWidget {
  final String url;
  FullPhotoScreen({this.url});

  @override
  State createState() => FullPhotoScreenState();
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Image'),
      ),
      body: Container(
        child: PhotoView(imageProvider: NetworkImage(widget.url)),
      ),
    );
  }
}
