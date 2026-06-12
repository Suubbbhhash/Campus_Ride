import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'bus_list_screen.dart';

class DriverRegister extends StatelessWidget {
  DriverRegister({super.key});

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final keyCtrl = TextEditingController();

  static const DRIVER_KEY = "DRIVERKEY123";
  final phoneRegex = RegExp(r'^[0-9]{10}$');

  void show(BuildContext c, String m) {
    ScaffoldMessenger.of(c).showSnackBar(
      SnackBar(content: Text(m)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.yellow),
        title: const Text(
          "Driver Registration",
          style: TextStyle(color: Colors.yellow),
        ),
      ),

      // ✅ THIS FIXES OVERFLOW
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // FULL NAME
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.yellow,
              decoration: const InputDecoration(
                labelText: "Full Name",
                labelStyle: TextStyle(color: Colors.yellow),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // SECRET KEY
            TextField(
              controller: keyCtrl,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.yellow,
              decoration: const InputDecoration(
                labelText: "Secret Key",
                labelStyle: TextStyle(color: Colors.yellow),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // PHONE NUMBER
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.yellow,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                labelStyle: TextStyle(color: Colors.yellow),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // CONTINUE BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () async {
                if (nameCtrl.text.isEmpty) {
                  show(context, "Name required");
                  return;
                }
                if (!phoneRegex.hasMatch(phoneCtrl.text)) {
                  show(context, "Invalid phone number");
                  return;
                }
                if (keyCtrl.text != DRIVER_KEY) {
                  show(context, "Invalid secret key");
                  return;
                }

                await SessionService.saveDriver(nameCtrl.text.trim());

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BusListScreen(
                      isDriver: true,
                      driverName: nameCtrl.text.trim(),
                    ),
                  ),
                      (_) => false,
                );
              },
              child: const Text(
                "CONTINUE",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
