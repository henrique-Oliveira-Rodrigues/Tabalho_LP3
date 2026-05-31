import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_layout.dart';
import 'login_screen.dart';
import 'splash_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Escuta o estado de autenticação do Firebase em tempo real.
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasData) {
          return const AppLayout(initialIndex: 0);
        }

        return const LoginScreen();
      },
    );
  }
}
