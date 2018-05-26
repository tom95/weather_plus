import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker extends StatefulWidget {
  final DocumentReference feedItemReference;

  MyImagePicker(this.feedItemReference);

  @override
  _MyImagePickerState createState() => new _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500.0,
        maxHeight: 500.0,
    );

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Column(
        children: <Widget>[
          _image == null
              ? new Text('No image selected.')
              : new Image.file(
                  _image,
                  height: 200.0,
                  width: 200.0,
                  fit: BoxFit.cover,
              ),
          new MaterialButton(
            onPressed: getImage,
            child: new Icon(Icons.add_a_photo),
          ),
        ],
      )
    );
  }
}
