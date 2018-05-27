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
                var cardChildren = <Widget>[
                  ListTile(
                    leading: Icon(Icons.comment),
                    title: new Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 22.0, 22.0, 22.02),
                      child: Text(document['text']),
                    ),
                  ),
                ];

                String imageName = document['image'];
                if (imageName != null) {
                  cardChildren.add(
                    new Container(
                      height: 200.0,
                      margin: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
                      child: new Image.network(imageName))
                  );
                }

                return Card(
                  margin: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                  child: new Column(
                    children: cardChildren
                  )
                );
              }
          ).toList());
        }
    );
  }
}
