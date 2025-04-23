import 'dart:convert';
import 'dart:ui';

import 'package:ecom_modwir/core/constant/keys.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

Future getPolyline(lat, long, destLat, destLong) async {
  List<LatLng> polylineCo = [];

  PolylinePoints polylinePoints = PolylinePoints();

  Set<Polyline> polylineSet = {};

  String url =
      "https://maps.googleapis.com/maps/api/directions/json?origin=$lat,$long&destination=$destLat,$destLong&key=$keyGoogleMap";

  var response = await http.post(Uri.parse(url));

  var responsebody = jsonDecode(response.body);

  var point = responsebody['routes'][0]['overview_polyline']['points'];

  List<PointLatLng> result = polylinePoints.decodePolyline(point);

  if (result.isNotEmpty) {
    for (var pointLatLng in result) {
      polylineCo.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
    }
  }

  Polyline polyline = Polyline(
    polylineId: PolylineId("modwir"),
    color: Color(0xff3498db),
    width: 5,
    points: polylineCo,
  );

  polylineSet.add(polyline);

  return polylineSet;
}
