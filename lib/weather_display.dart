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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherInformation>(
      future: fetchWeatherInformation()
    );
  }
}
