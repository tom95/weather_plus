import 'package:flutter/material.dart';
import 'dart:async';

class WeatherInformation {
  final int degrees;
  final String description;
  final String iconName;

  WeatherInformation({this.degrees, this.description, this.iconName});

  factory WeatherInformation.fromJson(Map<String, dynamic> json) {
    return WeatherInformation(
      degrees: json['degrees'],
      description: json['description'],
      iconName: json['iconName']
    );
  }
}

Future<WeatherInformation> fetchWeatherInformation() {
  return new Future.value(WeatherInformation(degrees: 20, description: "Cloudy", iconName: "clouds"));
}

class WeatherDisplay extends StatelessWidget {
  Widget _buildTemperature(BuildContext context, WeatherInformation data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            // Icon(Icons.wb_sunny),
            Expanded(child: Text(data.degrees.toString() + "°C", style: Theme.of(context).textTheme.display2)),
            new Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
              child: Icon(Icons.wb_cloudy, size: 48.0,),
            ),
            Text(data.description, style: Theme.of(context).textTheme.headline),
          ]),
    );
  }

  Widget _buildCurrentBox(BuildContext context, String title, String value, Color color) {
    return Expanded(child: Container(
      decoration: BoxDecoration(color: color),
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(value, style: Theme.of(context).textTheme.title),
            Text(title, style: Theme.of(context).textTheme.subhead),
          ],
        ),
      ),
    ));
  }

  Widget _buildCurrentSituation(BuildContext context, WeatherInformation data) {
    return Row(
      children: <Widget>[
        _buildCurrentBox(context, "Air Pollution", "20%", Colors.red[400]),
        VerticalDivider(width: 1.0),
        _buildCurrentBox(context, "Temperature", "22°C", Colors.green[400]),
        VerticalDivider(width: 1.0),
        _buildCurrentBox(context, "Wind", "3km/h", Colors.green[400]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherInformation>(
      future: fetchWeatherInformation(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.data.toString());
        }
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              _buildTemperature(context, snapshot.data),
              Divider(height: 1.0),
              _buildCurrentSituation(context, snapshot.data),
              Divider(height: 1.0)
            ],
          );
        }

        return new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new CircularProgressIndicator(),
        );
      },
    );
  }
}

class VerticalDivider extends StatelessWidget {
  final double width;
  final Color color;

  const VerticalDivider({
    Key key,
    this.width: 12.0,
    this.color
  }) : assert(width >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: width,
      child: new Center(
        child: new Container(
          height: 0.0,
          decoration: new BoxDecoration(
            border: new Border(
              right: BorderSide(color: color ?? Theme.of(context).dividerColor),
            ),
          ),
        ),
      ),
    );
  }
}