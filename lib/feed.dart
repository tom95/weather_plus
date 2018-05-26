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
            final int messageCount = snapshot.data.documents.length;
            return new ListView.builder(
              itemCount: messageCount,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (_, int index) {
                final DocumentSnapshot document = snapshot.data.documents[index];

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
              },
            );
          },
    );
  }
}
