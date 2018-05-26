import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weather_plus/feed_details.dart';

class Feed extends StatelessWidget {
  @override
  build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('feed').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');

        return new Column(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new FeedDetails(document)),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.cloud),
                  title: Text(document['title']),
                  trailing: Row(children: <Widget>[
                    Text(document['votes'].toString()),
                    Icon(Icons.person)
                  ])
                )
              )
            );
          }).toList());
      },
    );
  }
}
