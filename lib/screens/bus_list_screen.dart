import 'package:flutter/material.dart';
import '../models/bus_model.dart';
import '../services/firestore_service.dart';
import '../services/session_service.dart';
import 'map_screen.dart';
import 'role_select_screen.dart';

class BusListScreen extends StatelessWidget {
  final bool isDriver;
  final String? driverName;

  const BusListScreen({
    super.key,
    required this.isDriver,
    this.driverName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Bus"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SessionService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const RoleSelectScreen(),
                ),
                    (_) => false,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirestoreService.busesStream(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: sampleBuses.length,
            itemBuilder: (context, index) {
              final bus = sampleBuses[index];

              bool isActive = false;
              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  if (doc.id == bus.busNumber) {
                    isActive = doc['active'] == true;
                  }
                }
              }

              return Card(
                child: ListTile(
                  title: Text("Bus ${bus.busNumber}"),
                  subtitle: Text(bus.route),
                  trailing: Icon(
                    isActive ? Icons.circle : Icons.circle_outlined,
                    color: isActive ? Colors.green : Colors.red,
                  ),
                  onTap: () {
                    if (!isDriver && !isActive) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Bus NOT ACTIVE"),
                        ),
                      );
                      return;
                    }

                    if (isDriver) {
                      FirestoreService.startBus(
                        bus.busNumber,
                        driverName ?? "Unknown",
                        bus.route,
                      );
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapScreen(
                          busNumber: bus.busNumber,
                          isDriver: isDriver,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}