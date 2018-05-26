import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentForm extends StatefulWidget {
  final DocumentReference feedItemReference;
  CommentForm(this.feedItemReference);

  @override
  _CommentFormState createState() => new  _CommentFormState();
}

final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

class _CommentFormState extends State<CommentForm> {

  String commentText;

  String _validateText(String value) {
    if (value.isEmpty)
      return 'Comment text is required.';
    return null;
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      Firestore.instance.collection("comments").document()
          .setData({'text': commentText, 'feedItem': widget.feedItemReference});
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Thanks for your comment!"),
      ));
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
                labelText: 'Comment Text',
              ),
              onSaved: (String value) {
                commentText = value;
                },
              validator: _validateText,
              maxLines: 3,
            ),
            Center(
              child: new RaisedButton(
                child: const Text('Submit'),
                onPressed: _handleSubmitted,
              ),
            ),
          ]
      )
    );
  }
}