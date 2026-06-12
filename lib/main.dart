import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';
import 'screens/role_select_screen.dart';
import 'screens/bus_list_screen.dart';
import 'services/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.init();

  final role = await SessionService.getRole();
  final driverName = await SessionService.getDriverName();

  runApp(CampusRideApp(role: role, driverName: driverName));
}

class CampusRideApp extends StatelessWidget {
  final String? role;
  final String? driverName;

  const CampusRideApp({super.key, this.role, this.driverName});

  @override
  Widget build(BuildContext context) {
    Widget home;

    if (role == "student") {
      home = const BusListScreen(isDriver: false);
    } else if (role == "driver") {
      home = BusListScreen(isDriver: true, driverName: driverName);
    } else {
      home = const RoleSelectScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}