import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'config.dart' as config;

class Karte extends StatefulWidget {
  final LatLng latLng;

  Karte({Key key, this.latLng}) : super(key: key);

  @override
  _KarteState createState() => new _KarteState();
}

class _KarteState extends State<Karte> {

  @override
  build(BuildContext context) {
    Random rng = new Random(widget.latLng.hashCode);
    List<Marker> markers = [];

    for (int i = 0; i < 8; i++) {
      markers.add(new Marker(
        width: 40.0,
        height: 40.0,
        point: new LatLng(
            widget.latLng.latitude + 0.1 * (0.5 - rng.nextDouble()),
            widget.latLng.longitude + 0.3 * (0.5 - rng.nextDouble())
        ),
        builder: (ctx) => new Container(
          child: new Icon(Icons.location_on, size: 40.0, color: Theme.of(context).accentColor),
        ),
      ));
    }

    markers.add(new Marker(
      width: 50.0,
      height: 50.0,
      point: widget.latLng,
      builder: (ctx) => new Container(
        child: new Icon(Icons.location_on, size: 50.0, color: Theme.of(context).primaryColor),
      ),
    ));

    var map = new FlutterMap(
      options: new MapOptions(
        center: widget.latLng,
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

    return map;
  }
}
