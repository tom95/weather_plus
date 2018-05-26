import 'package:flutter/material.dart';

class Feed extends StatelessWidget {
  @override
  build(BuildContext context ) {
    return Scaffold(
        body: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                  leading: Icon(Icons.cloud),
                  title: Text(data[index]),
                  trailing: Row(
                    children: <Widget>[
                      Text("42"),
                      Icon(Icons.person)
                    ]
                  ))
            );
            },
          itemCount: data.length,
        )
    );
  }
}

final List<String> data = <String>["The air sucks!", "Why it is so hot?", "Storm!", "This is a very very very very very very long title"];