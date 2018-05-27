import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void _addTopic() {

  }

  Future<Map<String,double>> geoLocate() async {
    try {
      return await new Location().getLocation;
    } on PlatformException {
      return Future.error("Acquiring location data was not possible :(");
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<Map<String,double>>(
        future: geoLocate(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                WeatherDisplay(latitude: snapshot.data['latitude'], longitude: snapshot.data['longitude']),
                SizedBox(height: 200.0, child: Karte(
                    latitude: snapshot.data['latitude'], longitude: snapshot.data['longitude']
                )),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Feed(),
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
    );
  }
}
