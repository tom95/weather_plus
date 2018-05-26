import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentDisplay extends StatelessWidget {
  final DocumentReference feedItem;

  CommentDisplay(this.feedItem);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('comments').where('feedItem', isEqualTo: feedItem).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
          return Column(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.comment),
                    title: Text(document['text']),
                  )
                );
              }
          ).toList());
        }
    );
  }
}