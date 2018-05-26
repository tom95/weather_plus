import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VoteButton extends StatelessWidget {
  final DocumentReference feedItemReference;

  VoteButton(this.feedItemReference);

  void _vote() {
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot feedItemSnapshot = await tx.get(feedItemReference);
      if (feedItemSnapshot.exists) {
        await tx.update(feedItemReference, <String, dynamic>{'votes': feedItemSnapshot.data['votes'] + 1});
      }
    });
  }

  @override
  build(BuildContext context) {
    return MaterialButton(
      onPressed: _vote,
      child: Text('Upvote :+1:'),
    );
  }
}
