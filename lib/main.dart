import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/app_layout.dart';
import 'screens/auth_gate.dart';
import 'screens/cadastro_evento_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/evento_detalhe_screen.dart';
import 'screens/filtros_screen.dart';
import 'screens/login_screen.dart';


Future<void> main() async {
  // Garante que o Flutter esteja inicializado antes de usar plugins externos.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as opções geradas pelo FlutterFire CLI.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AgendaLocalApp());
}

class AgendaLocalApp extends StatelessWidget {
  const AgendaLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Local',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black).copyWith(
          primary: Colors.black,
          secondary: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(50),
            side: const BorderSide(color: Colors.black, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      // A rota inicial usa o AuthGate para decidir se abre login ou home.
      initialRoute: '/',
      routes: {
        '/': (_) => const AuthGate(),
        '/login': (_) => const LoginScreen(),
        '/cadastro': (_) => const CadastroScreen(),
        '/home': (_) => const AppLayout(initialIndex: 0),
        '/eventos': (_) => const AppLayout(initialIndex: 1),
        '/favoritos': (_) => const AppLayout(initialIndex: 2),
        '/perfil': (_) => const AppLayout(initialIndex: 3),
        '/filtros': (_) => const FiltrosScreen(),
        '/novo-evento': (_) => const CadastroEventoScreen(),
      },
      // Rota dinâmica para detalhes: /evento/ID_DO_DOCUMENTO_FIRESTORE.
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/evento/')) {
          final id = settings.name!.split('/').last;

          return MaterialPageRoute(
            builder: (_) => EventoDetalheScreen(eventoId: id),
          );
        }

        if (settings.name != null && settings.name!.startsWith('/editar-evento/')) {
          final id = settings.name!.split('/').last;

          return MaterialPageRoute(
            builder: (_) => CadastroEventoScreen(eventoId: id),
          );
        }

        return null;
      },
    );
  }
}
