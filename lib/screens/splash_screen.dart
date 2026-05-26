<<<<<<< HEAD
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A Splash agora não navega sozinha com Timer.
    // Quem decide o próximo destino é o AuthGate, com base no Firebase Auth.
=======
import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month_outlined, color: Colors.white, size: 80),
              SizedBox(height: 24),
              Text(
                'Agenda Local',
<<<<<<< HEAD
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
=======
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
              ),
              SizedBox(height: 100),
              CircularProgressIndicator(color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
