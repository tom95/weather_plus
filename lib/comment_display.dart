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
                    title: Text(document['text']),
                  ),
                ];

                String imageName = document['image'];
                if (imageName != null) {
                  cardChildren.add(
                    new Container(
                        height: 200.0,
                        child: new Image.network("https://firebasestorage.googleapis.com/v0/b/weatherplus-2bfb7.appspot.com/o/comment-images%2F"
                        + imageName + "?alt=media"))
                  );
                }

                return Card(
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
