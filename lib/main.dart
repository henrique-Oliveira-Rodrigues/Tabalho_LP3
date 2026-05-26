import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD
// Este arquivo é gerado pelo FlutterFire CLI.
// Se ele não existir no seu projeto, execute:
// flutterfire configure --project=projeto-agenda-e0465
import 'firebase_options.dart';

import 'screens/auth_gate.dart';
import 'screens/app_layout.dart';
import 'screens/cadastro_evento_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/evento_detalhe_screen.dart';
import 'screens/filtros_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  // Garante que o Flutter esteja inicializado antes de chamar plugins externos.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase usando as configurações da plataforma atual
  // Web, Android, iOS etc., geradas em firebase_options.dart.
=======
import 'Autenticacao.dart';
import 'CriarEvento.dart';
import 'cadastro.dart';
import 'detalhes.dart';
import 'filtros.dart';
import 'firebase_options.dart';
import 'lista.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

<<<<<<< HEAD
  // Após o Firebase iniciar, o aplicativo pode ser exibido.
=======
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
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
<<<<<<< HEAD
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
=======
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
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
<<<<<<< HEAD
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
=======
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
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
<<<<<<< HEAD

      // A primeira rota é o AuthGate, não mais a Splash fixa.
      // Ele decide automaticamente se o usuário está logado ou não.
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

      // Rotas dinâmicas para abrir os detalhes de um evento pelo ID.
      // Exemplo: /evento/ABC123
      onGenerateRoute: (settings) {
        final routeName = settings.name;

        if (routeName != null && routeName.startsWith('/evento/')) {
          final id = routeName.split('/').last;

          return MaterialPageRoute(
            builder: (_) => EventoDetalheScreen(eventoId: id),
          );
        }

=======
      initialRoute: '/',
      routes: {
        '/': (_) => const AuthGate(),
        '/login': (_) => const LoginPage(),
        '/cadastro': (_) => const CadastroPage(),
        '/lista': (_) => const ListaEventosPage(),
        '/novo-evento': (_) => const CriarEventoPage(),
        '/filtros': (_) => const FiltrosPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/evento/')) {
          final id = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (_) => DetalhesEventoPage(eventoId: id),
          );
        }
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
        return null;
      },
    );
  }
}
