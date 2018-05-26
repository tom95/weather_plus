import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Feed extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
        body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('baby').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading...');
            final int messageCount = snapshot.data.documents.length;
            return new ListView.builder(
              itemCount: messageCount,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (_, int index) {
                final DocumentSnapshot document = snapshot.data.documents[index];

                return Card(
                    child: ListTile(
                      leading: Icon(Icons.cloud),
                      title: Text(document['name']),
                      trailing: Row(children: <Widget>[
                          /*Text(document['votes']),*/ // TODO: Doesn't work.
                          Icon(Icons.person)
                      ])
                    )
                );
              },
            );
          },
        )
    );
  }
}
