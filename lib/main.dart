import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong/latlong.dart';
import 'package:weather_plus/feed.dart';
import 'package:weather_plus/file_storage.dart';
import 'weather_display.dart';
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
    return base.copyWith(
        title: base.title.copyWith(fontWeight: FontWeight.w700),
        display3: base.display3.copyWith(fontWeight: FontWeight.w700)
    ).apply(fontFamily: 'Raleway');
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
      'contactName': 'Jane Doe (me)',
      'avatarUrl': "http://i.pravatar.cc/100?img=5",
      'locationName': 'Potsdam',
      'latLng': null,
    },
    {
      'contactName': 'Eva Tapir',
      'avatarUrl': 'http://i.pravatar.cc/100?img=26',
      'locationName': 'Peking',
      'latLng': LatLng(39.956800, 116.400528),
    },
  ];

  var currentLocation;

  _MyHomePageState() {
    currentLocation = locations[0];
  }

  void _addTopic() {

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
        accountName: const Text('Jane Doe'),
        accountEmail: const Text('jane.doe@hpi.de'),
        currentAccountPicture: const CircleAvatar(
          backgroundImage: NetworkImage("http://i.pravatar.cc/100?img=5"),
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
            currentLocation = location;
          });
          Navigator.pop(context);
        },
      ));
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title, style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        leading: Icon(Icons.wb_sunny, color: Colors.white),
      ),
      body: FutureBuilder<LatLng>(
        future: currentLocation['latLng'] == null ? geoLocate() : new Future<LatLng>.value(currentLocation['latLng']),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                WeatherDisplay(latitude: snapshot.data.latitude, longitude: snapshot.data.longitude),
                SizedBox(height: 200.0, child: Karte(
                    latLng: snapshot.data
                )),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Feed(snapshot.data),
                ),
              ]);
          }
          return Center(child: CircularProgressIndicator());
        }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTopic,
        tooltip: 'Increment',
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
