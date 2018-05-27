import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'config.dart' as config;

class Karte extends StatelessWidget {
  final double latitude;
  final double longitude;
  final Random rng = new Random();

  Karte({Key key, this.latitude, this.longitude}) : super(key: key);

  @override
  build(BuildContext context) {
    List<Marker> markers = [];

    for (int i = 0; i < 8; i++) {
      markers.add(new Marker(
        width: 40.0,
        height: 40.0,
        point: new LatLng(latitude + 0.1 * (0.5 - rng.nextDouble()), longitude + 0.3 * (0.5 - rng.nextDouble())),
        builder: (ctx) => new Container(
          child: new Icon(Icons.location_on, size: 40.0, color: Theme.of(context).accentColor),
        ),
      ));
    }

    markers.add(new Marker(
      width: 50.0,
      height: 50.0,
      point: new LatLng(latitude, longitude),
      builder: (ctx) => new Container(
        child: new Icon(Icons.location_on, size: 50.0, color: Theme.of(context).primaryColor),
      ),
    ));

    return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(latitude, longitude),
        zoom: 10.0,
      ),
      layers: [
        new TileLayerOptions(
            urlTemplate:
            "https://{s}.tile.thunderforest.com/landscape/{z}/{x}/{y}.png?apikey={apikey}",
            subdomains: ['a', 'b', 'c'],
            additionalOptions: {
              'apikey': config.thunderForestMapAPIKey,
            },
        ),
        new MarkerLayerOptions(
          markers: markers,
        ),
      ],
    );
  }
}
