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
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 0.0),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            // Icon(Icons.wb_sunny),
            Expanded(
              child: Text(data.degrees.toString() + "°C", style: Theme.of(context).textTheme.display2),
            ),
            new Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.wb_cloudy),
            ),
            Text(data.description, style: Theme.of(context).textTheme.headline),
          ]),
    );
  }

  Widget _buildCurrentBox(BuildContext context, String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(color: color),
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text("20%", style: Theme.of(context).textTheme.title),
            Text("Air Pollution", style: Theme.of(context).textTheme.subhead)
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSituation(BuildContext context, WeatherInformation data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildCurrentBox(context, "Air Pollution", "20%", Colors.red[400]),
        _buildCurrentBox(context, "Temperature", "22°C", Colors.green[400])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherInformation>(
      future: fetchWeatherInformation(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              _buildTemperature(context, snapshot.data),
              Divider(),
              _buildCurrentSituation(context, snapshot.data)
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
