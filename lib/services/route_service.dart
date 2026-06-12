import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteService {
  // ✅ Full route through checkpoints
  static Future<List<LatLng>> getRouteThroughCheckpoints(
      LatLng start,
      List<LatLng> checkpoints,
      ) async {
    // Build coordinate string: lon,lat;lon,lat;lon,lat...
    String coordString =
        "${start.longitude},${start.latitude}";

    for (LatLng p in checkpoints) {
      coordString += ";${p.longitude},${p.latitude}";
    }

    final url =
        "https://router.project-osrm.org/route/v1/driving/"
        "$coordString?overview=full&geometries=geojson";

    final res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) return [];

    final data = jsonDecode(res.body);
    final coords = data["routes"][0]["geometry"]["coordinates"];

    return coords.map<LatLng>((c) {
      return LatLng(c[1], c[0]);
    }).toList();
  }
}