import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'lista.dart';
import 'login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashAgenda();
        }

        if (snapshot.hasData) {
          return const ListaEventosPage();
        }

        return const LoginPage();
      },
    );
  }
}

class SplashAgenda extends StatelessWidget {
  const SplashAgenda({super.key});

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
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
