import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:weather_plus/file_storage.dart';
import 'package:weather_plus/image_picker.dart';
import 'package:uuid/uuid.dart';

class CommentForm extends StatefulWidget {
  final DocumentReference feedItemReference;

  CommentForm(this.feedItemReference);

  @override
  _CommentFormState createState() => new  _CommentFormState();
}

final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

class _CommentFormState extends State<CommentForm> {

  String commentText;

  ValueNotifier<File> imageNotifier = new ValueNotifier<File>(null);

  String _validateText(String value) {
    if (value.isEmpty)
      return 'Comment text is required.';
    return null;
  }

  void _uploadImage(File image, String filename) async {
    final StorageReference ref = FileStorage.instance().ref()
        .child('comment-images') // Folder
        .child(filename);      // File name
    final StorageUploadTask uploadTask = ref.putFile(image);

    await uploadTask.future;
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      var comment = Firestore.instance.collection("comments").document();

      String imageName;
      if (imageNotifier.value != null) {
        Uuid uuid = new Uuid();
        imageName = uuid.v4() + '.jpg';
        _uploadImage(imageNotifier.value, imageName);
      }

      comment.setData({'text': commentText, 'feedItem': widget.feedItemReference, 'image': imageName});

      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Thanks for your comment!"),
      ));
      form.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'What is your opinion?',
                helperText: 'Share your opinions with the community',
                labelText: 'Your comment ...',
              ),
              onSaved: (String value) {
                commentText = value;
              },
              validator: _validateText,
              maxLines: 3,
            ),
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new MyImagePicker(imageNotifier),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: new OutlineButton(
                child: const Text('Submit'),
                onPressed: _handleSubmitted,
              ),
            ),
          ]
      )
    );
  }
}
