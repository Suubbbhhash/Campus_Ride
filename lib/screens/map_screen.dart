import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../constants/app_colors.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import '../services/session_service.dart';
import '../services/route_service.dart';

import '../services/notification_service.dart';
import '../services/checkpoint_service.dart';

class MapScreen extends StatefulWidget {
  final String busNumber;
  final bool isDriver;

  const MapScreen({
    super.key,
    required this.busNumber,
    required this.isDriver,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  StreamSubscription? _driverSub;
  Timer? _viewerTimer;
  String? viewerId;

  List<LatLng> fullRoute = [];
  List<LatLng> remainingRoute = [];
  bool routeLoaded = false;

  final Distance distance = Distance();

  String? preferredCheckpoint;
  Set<String> notified = {};

  // ✅ Checkpoints
  final Map<String, LatLng> checkpointMap = {
    "BVB": LatLng(15.368421, 75.120613),
    "President Hotel": LatLng(15.381992, 75.112920),
    "Shantiniketan": LatLng(15.391446, 75.098115),
    "Navnagar": LatLng(15.397262, 75.082451),
    "ISKCON": LatLng(15.405257, 75.069048),
    "KMF": LatLng(15.409004, 75.061080),
    "SDM Medical": LatLng(15.417323, 75.048192),
    "Navalur Bridge": LatLng(15.423570, 75.036498),
    "Gandhinagar": LatLng(15.437065, 75.019613),
    "Toll Naka": LatLng(15.447013, 75.012242),
    "SDMCET": LatLng(15.430472, 75.014518),
  };

  @override
  void initState() {
    super.initState();
    loadPreferred();

    // Driver shares location
    if (widget.isDriver) {
      LocationService.requestPermission().then((_) {
        _driverSub = LocationService.locationStream().listen((pos) {
          FirestoreService.updateBusLocation(
            widget.busNumber,
            pos.latitude,
            pos.longitude,
          );
        });
      });
    }

    // Student viewer
    if (!widget.isDriver) initViewer();
  }

  Future<void> loadPreferred() async {
    preferredCheckpoint = await CheckpointService.getCheckpoint();
    setState(() {});
  }

  Future<void> initViewer() async {
    viewerId = await SessionService.getViewerId();

    _viewerTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final pos = await LocationService.getCurrentLocation();
      if (pos != null && viewerId != null) {
        FirestoreService.addViewer(
          widget.busNumber,
          viewerId!,
          pos.latitude,
          pos.longitude,
        );
      }
    });
  }

  Future<void> loadRoute(LatLng busLoc) async {
    final points = await RouteService.getRouteThroughCheckpoints(
      busLoc,
      checkpointMap.values.toList(),
    );

    if (points.isNotEmpty) {
      setState(() {
        fullRoute = points;
        remainingRoute = points;
        routeLoaded = true;
      });
    }
  }

  void checkCrossing(LatLng busLoc) {
    if (widget.isDriver) return;

    for (var entry in checkpointMap.entries) {
      final name = entry.key;
      final point = entry.value;

      double meters = distance.as(LengthUnit.Meter, busLoc, point);

      if (meters < 80 && !notified.contains(name)) {
        notified.add(name);

        String extra = "";
        if (preferredCheckpoint != null) {
          final stop = checkpointMap[preferredCheckpoint]!;
          double km =
          distance.as(LengthUnit.Kilometer, busLoc, stop);
          int min = ((km / 30) * 60).round();
          extra = "\n$min min to your stop ($preferredCheckpoint)";
        }

        NotificationService.show(
          "Bus crossed $name",
          "CampusRide Update$extra",
        );
      }
    }
  }

  void openCheckpointPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      builder: (_) {
        return ListView(
          children: checkpointMap.keys.map((name) {
            return ListTile(
              title: Text(
                name,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () async {
                await CheckpointService.saveCheckpoint(name);
                preferredCheckpoint = name;
                setState(() {});
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  void dispose() {
    _viewerTimer?.cancel();
    _driverSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,

      // ✅ Back button visible now
      appBar: AppBar(
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.yellow),
        title: const Text(
          "Live Bus Tracking",
          style: TextStyle(color: AppColors.yellow),
        ),
      ),

      body: StreamBuilder(
        stream: FirestoreService.busStream(widget.busNumber),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          final data = snapshot.data!.data()!;
          final lat = (data["lat"] as num?)?.toDouble();
          final lng = (data["lng"] as num?)?.toDouble();

          if (lat == null || lng == null) {
            return const Center(
              child: Text("Waiting for driver...",
                  style: TextStyle(color: AppColors.grey)),
            );
          }

          final busLoc = LatLng(lat, lng);

          if (!routeLoaded) {
            Future.microtask(() => loadRoute(busLoc));
          }

          Future.microtask(() => checkCrossing(busLoc));

          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: busLoc,
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=Wjy51MX9CxLLGIVVnWI5",
                  ),

                  // ✅ Route
                  if (remainingRoute.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: remainingRoute,
                          strokeWidth: 6,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),

                  // ✅ Checkpoint dots restored
                  MarkerLayer(
                    markers: checkpointMap.values.map((p) {
                      return Marker(
                        point: p,
                        width: 10,
                        height: 10,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.yellow,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // ✅ Yellow bus icon
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: busLoc,
                        width: 60,
                        height: 60,
                        child: const Icon(
                          Icons.directions_bus,
                          color: Colors.yellow,
                          size: 45,
                        ),
                      )
                    ],
                  ),
                ],
              ),

              // ✅ TOP INFO BOX RESTORED
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bus ${widget.busNumber}",
                        style: const TextStyle(
                          color: AppColors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Driver: ${data['driverName'] ?? 'N/A'}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (!widget.isDriver && preferredCheckpoint != null)
                        Text(
                          "Your Stop: $preferredCheckpoint",
                          style: const TextStyle(color: Colors.greenAccent),
                        ),
                    ],
                  ),
                ),
              ),

              // ✅ CHECKPOINT BUTTON
              if (!widget.isDriver)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      padding: const EdgeInsets.all(14),
                    ),
                    onPressed: openCheckpointPicker,
                    child: const Text(
                      "CHECKPOINTS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}