import 'package:flutter/material.dart';
import 'package:weather_plus/feed.dart';
import 'weather_display.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  ThemeData _buildTheme(ThemeData base) {
    return base.copyWith(
        accentColor: Colors.red[400],
        primaryColor: const Color(0xFF33691E),
        primaryIconTheme: base.iconTheme.copyWith(opacity: 0.1)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Weather Plus',
      theme: _buildTheme(ThemeData.light()),
      home: new MyHomePage(title: 'Weather Plus'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
        title: new Text(widget.title),
        leading: Icon(Icons.wb_sunny),
      ),
      body: ListView(
          children: <Widget>[
            WeatherDisplay(),
            Feed(),
            SizedBox(
              height: 200.0,
              child: Feed(),
            )
          ],
    ),
      floatingActionButton: new FloatingActionButton(
        // onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
