import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_plus/comment_display.dart';
import 'package:weather_plus/comment_form.dart';
import 'package:weather_plus/problem_action_display.dart';

class FeedDetails extends StatefulWidget {

  final DocumentSnapshot feedItem;

  FeedDetails(this.feedItem);

  @override
  _FeedDetailsState createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {

  bool hasVoted = false;
  BuildContext innerContext;

  void _vote(BuildContext context, DocumentReference feedItemReference) {
    if (innerContext == null)
      return;

    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot feedItemSnapshot = await tx.get(feedItemReference);
      if (feedItemSnapshot.exists) {
        setState(() {
          hasVoted = true;
        });

        Scaffold.of(innerContext).showSnackBar(new SnackBar(
          content: Text("Saved! Thanks for confirming."),
        ));
        await tx.update(feedItemReference, <String, dynamic>{'votes': feedItemSnapshot.data['votes'] + 1});
      } else {
        Scaffold.of(innerContext).showSnackBar(new SnackBar(
          content: Text("There was an error saving! :("),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.feedItem.data['title']),
        leading: new GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: new Builder(builder: (context) {
        innerContext = context;

        return new Center(
            child: new ListView(
                children: <Widget>[
                  new ProblemActionDisplay(feedItem: widget.feedItem),
                  new CommentDisplay(widget.feedItem.reference),
                  new Card(
                      margin: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 8.0, 8.0, 8.0),
                      child: new Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: new CommentForm(widget.feedItem.reference),
                      ))
                ]
            )
        );
      }),
      floatingActionButton: !hasVoted ? FloatingActionButton.extended(
          onPressed: () { _vote(context, widget.feedItem.reference); },
          icon: const Icon(Icons.bug_report),
          label: Text('Confirm', style: new TextStyle(fontWeight: FontWeight.bold))
      ) : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
