import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextStyle continuousTextStyle = new TextStyle(height: 1.5, fontSize: 16.0);

class ProblemActionDisplay extends StatefulWidget {
  final DocumentSnapshot feedItem;

  ProblemActionDisplay({Key key, this.feedItem}): super(key: key);
  ProblemActionDisplayState createState() => new ProblemActionDisplayState();
}

class ProblemActionDisplayState extends State<ProblemActionDisplay> {
  List<bool> itemsExpanded = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
              itemsExpanded[index] = !isExpanded;
          });
        },
        children: <ExpansionPanel>[
          new ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return new Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Row(
                      children: <Widget>[
                        Icon(Icons.remove_red_eye),
                        new Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text('What to look out for?', style: Theme.of(context).textTheme.title),
                        )
                      ],
                    )),
              );
            },
            body: new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Align(
                  alignment: Alignment.centerLeft,
                  child: new Text(widget.feedItem.data['look_out'] ?? '', style: continuousTextStyle)),
            ),
            isExpanded: itemsExpanded[0],
          ),
          new ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return new Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Row(
                      children: <Widget>[
                        Icon(Icons.error_outline),
                        new Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text('What is the problem?', style: Theme.of(context).textTheme.title),
                        )
                      ],
                    )),
              );
            },
            body: new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Align(
                alignment: Alignment.centerLeft,
                child: new Text(widget.feedItem.data['problem'] ?? '', style: continuousTextStyle)),
            ),
            isExpanded: itemsExpanded[1],
          ),
          new ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return new Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Row(children: <Widget>[
                        Icon(Icons.check),
                        new Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text("What can I change?", style: Theme.of(context).textTheme.title),
                        )])
                ));
            },
            body: new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Align(
                  alignment: Alignment.centerLeft,
                  child: new Text(widget.feedItem.data['action'] ?? '', style: continuousTextStyle)),
            ),
            isExpanded: itemsExpanded[2],
          ),
        ]
      ),
    );
  }
}
