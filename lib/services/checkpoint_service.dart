import 'package:shared_preferences/shared_preferences.dart';

class CheckpointService {
  static const _key = "preferredCheckpoint";

  static Future<void> saveCheckpoint(String name) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, name);
  }

  static Future<String?> getCheckpoint() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_key);
  }
}