import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/app_layout.dart';
import 'screens/filtros_screen.dart';
import 'screens/evento_detalhe_screen.dart';
import 'screens/cadastro_evento_screen.dart';

void main() {
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
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/cadastro': (_) => const CadastroScreen(),
        '/home': (_) => const AppLayout(initialIndex: 0),
        '/eventos': (_) => const AppLayout(initialIndex: 1),
        '/favoritos': (_) => const AppLayout(initialIndex: 2),
        '/perfil': (_) => const AppLayout(initialIndex: 3),
        '/filtros': (_) => const FiltrosScreen(),
        '/novo-evento': (_) => const CadastroEventoScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/evento/')) {
          final id = settings.name!.split('/').last;
          return MaterialPageRoute(builder: (_) => EventoDetalheScreen(eventoId: id));
        }
        return null;
      },
    );
  }
}
