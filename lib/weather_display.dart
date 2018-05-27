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

const POSITIVE_COLOR = Color(0xFFAED581);
const NEGATIVE_COLOR = Color(0xFFFFB94E);
const TERRIBLE_COLOR = Color(0xFFE65400);

Color colorForAQI(int aqi) {
  if (aqi < 100) {
    return POSITIVE_COLOR;
  } else if (aqi < 150) {
    return NEGATIVE_COLOR;
  } else {
    return TERRIBLE_COLOR;
  }
}

Color colorForTemperature(int degrees) {
  if (degrees < 30) {
    return POSITIVE_COLOR;
  } else if (degrees < 40) {
    return NEGATIVE_COLOR;
  } else {
    return TERRIBLE_COLOR;
  }
}

Color colorForWindSpeed(double speed) {
  if (speed < 17.2) { // above this is considered a storm
    return POSITIVE_COLOR;
  } else if (speed < 28.5){ // above this is considered hurricane-like
    return NEGATIVE_COLOR;
  } else {
    return TERRIBLE_COLOR;
  }
}

Future<int> fetchAirPollutionInformation(double latitude, double longitude) async {
  final apiKey = config.aqicnAPIKey;
  final response = await http.get('https://api.waqi.info/feed/geo:$latitude;$longitude/?token=$apiKey');
  final jsonResponse = json.decode(response.body);

  if (jsonResponse == null || jsonResponse["data"] == null) {
    return Future.error("Whoops, AQICN had a hickup!");
  }

  return jsonResponse["data"]["aqi"];
}

Future<WeatherInformation> fetchWeatherInformation(double latitude, double longitude) async {
    final apiKey = config.openWeatherMapAPIKey;
    final response = await http.get('https://api.openweathermap.org/data/2.5/weather?units=metric&lat=$latitude&lon=$longitude&appid=$apiKey');
    final responseJson = json.decode(response.body);

    return new WeatherInformation.fromJson(responseJson);
}

String capitalizeWords(String w) {
  return w.split(" ").map((w) => w[0].toUpperCase() + w.substring(1)).join(" ");
}

class WeatherDisplay extends StatelessWidget {
  final double latitude;
  final double longitude;

  WeatherDisplay({Key key, this.latitude, this.longitude}) : super(key: key);

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
            Text(capitalizeWords(data.description), style: Theme.of(context).textTheme.headline),
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
            Text(title, style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black54)),
          ],
        ),
      ),
    ));
  }

  Widget _buildCurrentSituation(BuildContext context, WeatherInformation weather, int aqi) {
    return Row(
      children: <Widget>[
        _buildCurrentBox(context, "Air Pollution", aqi.toString() + " AQI", colorForAQI(aqi)),
        VerticalDivider(width: 1.0),
        _buildCurrentBox(context, "Temperature", weather.degrees.toString() + "°C", colorForTemperature(weather.degrees)),
        VerticalDivider(width: 1.0),
        _buildCurrentBox(context, "Wind", weather.windSpeed.toString() + "m/s", colorForWindSpeed(weather.windSpeed)),
        VerticalDivider(width: 1.0),
        _buildCurrentBox(context, "Rain", "30%", const Color(0xFFAED581)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: Future.wait([
        fetchWeatherInformation(this.latitude, this.longitude),
        fetchAirPollutionInformation(this.latitude, this.longitude)
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: <Widget>[
              _buildTemperature(context, snapshot.data[0]),
              Divider(height: 1.0),
              _buildCurrentSituation(context, snapshot.data[0], snapshot.data[1]),
              Divider(height: 1.0)
            ],
          );
        }

        return new Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(child: new CircularProgressIndicator()),
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
