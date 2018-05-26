
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_plus/comment_form.dart';
import 'package:weather_plus/image_picker.dart';
import 'package:weather_plus/problem_action_display.dart';
import 'package:weather_plus/vote_button.dart';

class FeedDetails extends StatelessWidget {
  final DocumentSnapshot feedItem;

  FeedDetails(this.feedItem);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('huhuhu'),
          leading: Icon(Icons.wb_sunny),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new ProblemActionDisplay(),
              new VoteButton(this.feedItem.reference),
              new CommentForm(this.feedItem.reference),
              new MyImagePicker(this.feedItem.reference),
              new Text('test')
            ]
          )
        )
    );
  }
}
