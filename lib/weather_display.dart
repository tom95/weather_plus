import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart' as config;

class WeatherInformation {
  final int degrees;
  final String description;
  final String iconName;
  final double windSpeed;

  WeatherInformation({this.degrees, this.description, this.iconName, this.windSpeed});

  factory WeatherInformation.fromJson(Map<String, dynamic> json) {
    return WeatherInformation(
      degrees: json['main']['temp'].round(),
      description: json['weather'][0]['description'],
      iconName: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'].toDouble()
    );
  }
}

Future<WeatherInformation> fetchWeatherInformation(double latitude, double longitude) async {
    final apiKey = config.openWeatherMapAPIKey;
    final response = await http.get('https://api.openweathermap.org/data/2.5/weather?units=metric&lat=$latitude&lon=$longitude&appid=$apiKey');
    final responseJson = json.decode(response.body);

    return new WeatherInformation.fromJson(responseJson);
}

class WeatherDisplay extends StatefulWidget {
  final double latitude;
  final double longitude;

  WeatherDisplay({Key key, this.latitude, this.longitude}) : super(key: key);

  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {

  Widget _buildTemperature(BuildContext context, WeatherInformation data) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            // Icon(Icons.wb_sunny),
            Expanded(child: Text(data.degrees.toString() + "°C", style: Theme.of(context).textTheme.display3)),
            new Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
              child: Icon(Icons.wb_sunny, size: 48.0, color: Theme.of(context).textTheme.display3.color),
            ),
            Text(data.description[0].toUpperCase() + data.description.substring(1), style: Theme.of(context).textTheme.headline),
          ]),
    );
  }

  Widget _buildCurrentBox(BuildContext context, String title, String value, Color color) {
    return Expanded(child: Container(
      decoration: BoxDecoration(color: color),
      child: new Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0.0),
        child: Column(
          children: <Widget>[
            Text(value, style: Theme.of(context).textTheme.title.copyWith(color: Colors.black54)),
            Text(title, style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black54)),
          ],
        ),
      ),
    ));
  }

  Widget _buildCurrentSituation(BuildContext context, WeatherInformation data) {
    return Row(
      children: <Widget>[
        _buildCurrentBox(context, "Air Pollution", "20%", const Color(0xFFFFB94E)),
        VerticalDivider(width: 1.0),
        _buildCurrentBox(context, "Temperature", data.degrees.toString() + "°C", const Color(0xFFAED581)),
        VerticalDivider(width: 1.0),
        _buildCurrentBox(context, "Wind", data.windSpeed.toString() + "km/h", const Color(0xFFAED581)),
        VerticalDivider(width: 1.0),
        _buildCurrentBox(context, "Rain", "10%", const Color(0xFFAED581)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherInformation>(
      future: fetchWeatherInformation(widget.latitude, widget.longitude),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
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
