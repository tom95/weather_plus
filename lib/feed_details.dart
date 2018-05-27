import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_plus/comment_display.dart';
import 'package:weather_plus/comment_form.dart';
import 'package:weather_plus/problem_action_display.dart';
import 'package:weather_plus/vote_button.dart';

class FeedDetails extends StatelessWidget {
  final DocumentSnapshot feedItem;

  FeedDetails(this.feedItem);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.feedItem.data['title']),
        leading: new GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: new Center(
        child: new ListView(
          children: <Widget>[
            new ProblemActionDisplay(feedItem: feedItem),
            new CommentDisplay(this.feedItem.reference),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new CommentForm(this.feedItem.reference),
            ),
          ]
        )
      ),
      floatingActionButton: new VoteButton(this.feedItem.reference),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
