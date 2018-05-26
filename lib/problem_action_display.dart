import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProblemActionDisplay extends StatefulWidget {
  final DocumentSnapshot feedItem;

  ProblemActionDisplay({Key key, this.feedItem}): super(key: key);
  ProblemActionDisplayState createState() => new ProblemActionDisplayState();
}

class ProblemActionDisplayState extends State<ProblemActionDisplay> {
  List<bool> itemsExpanded = <bool>[false, false];

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
                    child: new Text('What is the problem?', style: Theme.of(context).textTheme.title)),
              );
            },
            body: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Align(alignment: Alignment.centerLeft,child: new Text(widget.feedItem.data['problem'])),
            ),
            isExpanded: itemsExpanded[0],
          ),
          new ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return new Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text("What can I do?", style: Theme.of(context).textTheme.title)),
              );
            },
            body: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Align(alignment: Alignment.centerLeft,child: new Text(widget.feedItem.data['action'])),
            ),
            isExpanded: itemsExpanded[1],
          ),
        ]
      ),
    );
  }
}
