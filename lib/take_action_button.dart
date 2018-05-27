import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';


class TakeActionButton extends StatelessWidget {

  TakeActionButton();

  void _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
    // TODO handle error case
  }

  void _takeAction(context) {
    showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
      return ListView(
        children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Sign the Petition'),
              subtitle: Text('Show Strength in Numbers!'),
              onTap: () {
              _openUrl('https://beyond-coal.eu/take-action/');
              },
            ),
            ListTile(
            leading: Icon(Icons.email),
            title: Text('Contact your Local Governor'),
            subtitle: Text('via Bundestag-Kontakt'),
            onTap: () {
              _openUrl('https://www.bundestag.de/service/formular/contactform?mdbId=523480');
            },
          ),
          ListTile(
            leading: Icon(Icons.offline_bolt),
            title: Text('Contact Owner of Closest Coal Plant'),
            subtitle: Text('owned by Vattenfall'),
            onTap: () {
              _openUrl('https://www.vattenfall.de/service/kontakt');
            },
          ),
          ListTile(
            leading: Icon(Icons.nature),
            title: Text('Support Reforestation'),
            subtitle: Text('offset the damage'),
            onTap: () {
              _openUrl('https://www.arkive.org/donate.html');
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share With Friends'),
            subtitle: Text('spread awareness'),
            onTap: () {
              // TODO deeplink into app/its web equivalent
              Share.share('http://example.com');
            },
          ),
        ],
      );
    });

  }

  @override
  build(BuildContext context) {
    return RaisedButton.icon(
        onPressed: (){_takeAction(context);},
        icon: const Icon(Icons.gavel, size: 18.0),
        label: Text('Take Action Now'.toUpperCase(), style: new TextStyle(fontWeight: FontWeight.bold))
    );
  }
}