import 'package:flutter/material.dart';

class ProblemActionDisplay extends StatefulWidget {
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
                child: new Text('What is the problem?', style: Theme.of(context).textTheme.title),
              );
            },
            body: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text("The problem"),
            ),
            isExpanded: itemsExpanded[0],
          ),
          new ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return new Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                child: new Text("What can I do?", style: Theme.of(context).textTheme.title),
              );
            },
            body: new Text("The solution"),
            isExpanded: itemsExpanded[1],
          ),
        ]
      ),
    );
  }
}
