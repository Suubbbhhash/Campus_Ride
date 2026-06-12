import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/session_service.dart';
import 'bus_list_screen.dart';

class StudentRegister extends StatelessWidget {
  StudentRegister({super.key});

  final nameCtrl = TextEditingController();
  final usnCtrl = TextEditingController();

  // ✅ Name: Only alphabets + spaces
  final nameRegex = RegExp(r'^[A-Za-z ]+$');

  // ✅ USN Format: 2SD23AI041 / 2SD26CS489
  final usnRegex = RegExp(r'^2SD\d{2}[A-Z]{2}\d{3}$');

  void show(BuildContext c, String m) {
    ScaffoldMessenger.of(c).showSnackBar(
      SnackBar(content: Text(m)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.yellow),
        title: const Text(
          "Student Registration",
          style: TextStyle(color: AppColors.yellow),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ✅ Name Input
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              cursorColor: AppColors.yellow,
              decoration: const InputDecoration(
                labelText: "Full Name",
                labelStyle: TextStyle(color: AppColors.yellow),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ USN Input
            TextField(
              controller: usnCtrl,
              style: const TextStyle(color: Colors.white),
              cursorColor: AppColors.yellow,
              decoration: const InputDecoration(
                labelText: "USN (Example: 2SD23AI041)",
                labelStyle: TextStyle(color: AppColors.yellow),
              ),
            ),

            const SizedBox(height: 35),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final usn = usnCtrl.text.trim().toUpperCase();

                if (name.isEmpty || !nameRegex.hasMatch(name)) {
                  show(context, "Enter valid name (alphabets only)");
                  return;
                }

                if (!usnRegex.hasMatch(usn)) {
                  show(context, "Enter valid USN like 2SD23AI041");
                  return;
                }

                await SessionService.saveStudent();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BusListScreen(isDriver: false),
                  ),
                      (_) => false,
                );
              },
              child: const Text(
                "CONTINUE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}