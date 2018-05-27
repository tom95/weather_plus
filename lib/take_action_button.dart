import 'package:flutter/material.dart';

class TakeActionButton extends StatelessWidget {

  TakeActionButton();

  void _take_action(context) {
    showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
      return new Container(
          child: new Padding(
              padding: const EdgeInsets.all(32.0),
              child: new Text('This is the modal bottom sheet. Click anywhere to dismiss.',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 24.0
                  )
              )
          )
      );
    });

  }

  @override
  build(BuildContext context) {
    return RaisedButton.icon(
        onPressed: (){_take_action(context);},
        icon: const Icon(Icons.gavel, size: 18.0),
        label: Text('Take Action Now!', style: new TextStyle(fontWeight: FontWeight.bold))
    );
  }
}