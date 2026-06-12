import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'student_register.dart';
import 'driver_register.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(22),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.directions_bus,
                  size: 52, color: AppColors.yellow),
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => StudentRegister()));
                },
                child: const Text("STUDENT",
                    style: TextStyle(color: Colors.black)),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => DriverRegister()));
                },
                child: const Text("DRIVER",
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}