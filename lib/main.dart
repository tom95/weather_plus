import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong/latlong.dart';
import 'package:weather_plus/feed.dart';
import 'package:weather_plus/file_storage.dart';
import 'weather_display.dart';
import 'comment_form.dart';
import 'package:location/location.dart';
import 'karte.dart';
import 'dart:async';

void main() async {
  final FirebaseApp app = FirebaseStorage.instance.app;
  FileStorage.initialize(app);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  TextTheme _buildTextTheme(TextTheme base) {
    return base
        .copyWith()
        .apply(fontFamily: 'Open Sans')
        .copyWith(
          title: base.title.copyWith(fontWeight: FontWeight.normal, fontFamily: 'WWF'),
          display3: base.display3.copyWith(fontWeight: FontWeight.normal, fontFamily: 'WWF'),
          headline: base.headline.copyWith(fontFamily: 'Open Sans', fontSize: 18.0)
        );
  }

  ThemeData _buildTheme(ThemeData base) {
    return base.copyWith(
      accentColor: const Color(0xFFFFCD81),
      primaryColor: const Color(0xFF7CB342),
      buttonColor: const Color(0xFFFFCD81),
      primaryIconTheme: base.iconTheme.copyWith(opacity: 0.1),
      textTheme: _buildTextTheme(base.textTheme)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Weather Plus',
      theme: _buildTheme(ThemeData.light()),
      home: new MyHomePage(title: 'Weather Plus'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final locations = [
    {
      'contactName': 'Tom (me)',
      'avatarUrl': "http://tmbe.me/c/avatar.jpeg",
      'locationName': 'Potsdam',
      'email': 'thetom@theadress.com',
      'latLng': null,
    },
    {
      'contactName': 'Eva Tapir',
      'avatarUrl': 'http://i.pravatar.cc/100?img=26',
      'locationName': 'Peking',
      'email': 'eva@heradress.com',
      'latLng': LatLng(39.9, 116.3),
      // 'latLng': LatLng(39.9546044,116.4640594),
      //'latLng': LatLng(39.956800, 116.400528),
    },
  ];

  var currentLocation;
  var topicTitle;

  _MyHomePageState() {
    currentLocation = locations[0];
  }

  void _addTopic() {
    showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
      return ListView(
        children: <Widget>[
          new TextField(
            decoration: const InputDecoration(
                labelText: 'Topic Title',
                filled: true
            ),
            style: Theme.of(context).textTheme.headline,
            onChanged: (String value) {
              setState(() {
                topicTitle = value;
              });
            }),
          CommentForm(null)
        ],
      );
    });
  }

  Future<LatLng> geoLocate() async {
    try {
      var location = await new Location().getLocation;
      return new LatLng(location['latitude'], location['longitude']);
    } on PlatformException {
      return Future.error("Acquiring location data was not possible :(");
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawerChildren = <Widget>[
      new UserAccountsDrawerHeader(
        accountName: Text(locations[0]['contactName']),
        accountEmail: Text(locations[0]['email']),
        currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage(locations[0]['avatarUrl']),
        ),
        margin: EdgeInsets.zero,
      ),
    ];
    for (var location in locations) {
      drawerChildren.add(ListTile(
        title: new Text(location['contactName']),
        leading: new CircleAvatar(backgroundImage: new NetworkImage(location['avatarUrl'])),
        trailing: new Text(location['locationName'].toString().toUpperCase(), style: Theme.of(context).textTheme.caption),
        onTap: () {
          setState(() {
            Navigator.pop(context);
            currentLocation = location;
          });
        },
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title, style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        titleSpacing: 0.0,
      ),
      body: FutureBuilder<LatLng>(
        future: currentLocation['latLng'] == null ? geoLocate() : new Future<LatLng>.value(currentLocation['latLng']),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // var loc = this.currentLocation['latLng'] != null ? LatLng(39.9546044, 116.4640594) : snapshot.data;
            var loc = snapshot.data;

            return ListView(
              children: <Widget>[
                WeatherDisplay(latitude: loc.latitude, longitude: loc.longitude),
                SizedBox(height: 200.0, child: Karte(
                    latLng: loc
                )),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Feed(loc),
                ),
              ]);
          }
          return Center(child: CircularProgressIndicator());
        }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTopic,
        foregroundColor: Colors.black,
        label: Text('Topic'.toUpperCase()),
        icon: new Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: drawerChildren
        )
      ),
    );
  }
}
