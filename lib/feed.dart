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
                margin: EdgeInsets.all(8.0),
                child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.cloud),
                    title: Text(document['title'] ?? ''),
                    trailing: Row(children: <Widget>[
                      Text(document['votes'].toString()),
                      Icon(Icons.person)
                    ]),
                    subtitle: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('comments')
                          .where("image", isGreaterThan: "")
                          .where("feedItem", isEqualTo: document.reference).limit(5).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Row(
                              children: snapshot.data.documents.map((document) {
                                return new Padding(
                                  padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 0.0),
                                  child: Image.network("https://firebasestorage.googleapis.com/v0/b/weatherplus-2bfb7.appspot.com/o/comment-images%2F${document['image']}?alt=media",
                                    width: 32.0,
                                    height: 32.0,
                                    fit: BoxFit.cover),
                                );
                              }).toList());
                        } else {
                          return Container(width: 0.0, height: 0.0);
                        }
                      }),
                    ),
                ),
                )
            );
          }).toList());
      },
    );
  }
}
