import 'package:flutter/material.dart';

class ProblemActionDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new ExpansionPanelList(
        children: <ExpansionPanel>[
          new ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text('What is the problem?'),
              );
            },
            body: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text("The problem"),
            ),
            isExpanded: true,
          ),
          new ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return new Text("What can I do?");
            },
            body: new Text("The solution"),
            isExpanded: false,
          ),
        ],
        expansionCallback: (int index, bool isExpanded) {
          isExpanded = !criteria.children[index].isExpanded;
        },
      ),
    );
  }
}