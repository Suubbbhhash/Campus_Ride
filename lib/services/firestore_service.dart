import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  // ---------------- BUS CONTROL ----------------

  static Future<void> startBus(
      String busNumber,
      String driverName,
      String route,
      ) async {
    await _db.collection('buses').doc(busNumber).set({
      'active': true,
      'driverName': driverName,
      'route': route,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> updateBusLocation(
      String busNumber,
      double lat,
      double lng,
      ) async {
    await _db.collection('buses').doc(busNumber).set({
      'lat': lat,
      'lng': lng,
      'active': true,
      'lastUpdate': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> stopBus(String busNumber) async {
    await _db.collection('buses').doc(busNumber).set({
      'active': false,
    }, SetOptions(merge: true));
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> busStream(
      String busNumber) {
    return _db.collection('buses').doc(busNumber).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> busesStream() {
    return _db.collection('buses').snapshots();
  }

  // ---------------- VIEWER SYSTEM ----------------
  // Student becomes a viewer of ONE bus

  static Future<void> addViewer(
      String busNumber,
      String viewerId,
      double lat,
      double lng,
      ) async {
    await _db
        .collection("buses")
        .doc(busNumber)
        .collection("viewers")
        .doc(viewerId)
        .set({
      "lat": lat,
      "lng": lng,
      "lastActive": FieldValue.serverTimestamp(),
    });
  }

  static Future<void> removeViewer(
      String busNumber,
      String viewerId,
      ) async {
    await _db
        .collection("buses")
        .doc(busNumber)
        .collection("viewers")
        .doc(viewerId)
        .delete();
  }

  // Driver sees ONLY viewers of his bus
  static Stream<QuerySnapshot<Map<String, dynamic>>> viewersStream(
      String busNumber) {
    return _db
        .collection("buses")
        .doc(busNumber)
        .collection("viewers")
        .snapshots();
  }
}