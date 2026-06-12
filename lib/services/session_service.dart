import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class SessionService {
  static const _roleKey = "role";
  static const _driverNameKey = "driverName";
  static const _viewerIdKey = "viewerId";

  static Future<void> saveStudent() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_roleKey, "student");

    // Generate unique viewer id if not exists
    if (!p.containsKey(_viewerIdKey)) {
      final id = "viewer_${Random().nextInt(99999999)}";
      await p.setString(_viewerIdKey, id);
    }
  }

  static Future<void> saveDriver(String name) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_roleKey, "driver");
    await p.setString(_driverNameKey, name);
  }

  static Future<String?> getViewerId() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_viewerIdKey);
  }

  static Future<String?> getRole() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_roleKey);
  }

  static Future<String?> getDriverName() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_driverNameKey);
  }

  static Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.clear();
  }
}