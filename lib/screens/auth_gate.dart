import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_layout.dart';
import 'login_screen.dart';
import 'splash_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // O StreamBuilder escuta mudanças no estado de autenticação.
    // Quando o usuário faz login ou logout, essa tela é reconstruída automaticamente.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Enquanto o Firebase verifica se há uma sessão salva, mostramos o Splash.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // Se existe um usuário no snapshot, significa que ele está logado.
        if (snapshot.hasData) {
          return const AppLayout(initialIndex: 0);
        }

        // Se não existe usuário, o app abre a tela de login.
        return const LoginScreen();
      },
    );
  }
}
