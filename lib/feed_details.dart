import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_plus/comment_display.dart';
import 'package:weather_plus/comment_form.dart';
import 'package:weather_plus/problem_action_display.dart';
import 'package:weather_plus/take_action_button.dart';

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
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        titleSpacing: 0.0,
        title: new Text(widget.feedItem.data['title'], style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
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
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TakeActionButton(),
                  ),
                  new CommentDisplay(widget.feedItem.reference),
                  new Card(
                      margin: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 8.0, 8.0, 8.0),
                      child: new Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: new CommentForm(widget.feedItem.reference),
                      )),
                  Container(height: 100.0)
                ]
            )
        );
      }),
      floatingActionButton: !hasVoted ? FloatingActionButton.extended(
          onPressed: () { _vote(context, widget.feedItem.reference); },
          icon: const Icon(Icons.bug_report),
          foregroundColor: Colors.black,
          label: Text('Confirm'.toUpperCase())
      ) : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
