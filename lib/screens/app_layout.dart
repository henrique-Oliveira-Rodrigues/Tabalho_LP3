<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

=======
import 'package:flutter/material.dart';
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
import 'home_screen.dart';

class AppLayout extends StatefulWidget {
  final int initialIndex;
<<<<<<< HEAD

=======
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
  const AppLayout({super.key, this.initialIndex = 0});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

<<<<<<< HEAD
  Future<void> sair() async {
    // Encerra a sessão no Firebase Auth.
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    // Limpa o histórico e volta para o AuthGate/login.
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;

    // As páginas de Eventos/Favoritos/Perfil ainda usam telas simples.
    // A Home concentra a listagem real do Firestore.
    final pages = [
      const HomeScreen(title: 'Descobrir Eventos'),
      const HomeScreen(title: 'Eventos'),
      const _PlaceholderPage(
        title: 'Favoritos',
        message: 'Área reservada para eventos favoritos.',
      ),
      _PerfilPage(
        email: usuario?.email ?? 'Usuário sem email',
        nome: usuario?.displayName ?? 'Usuário',
        onLogout: sair,
      ),
=======
  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const HomeScreen(title: 'Eventos'),
      const HomeScreen(title: 'Favoritos'),
      const HomeScreen(title: 'Perfil'),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
    ];

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: pages[_index],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
<<<<<<< HEAD
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      floatingActionButton: _index == 0 || _index == 1
=======
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: 'Eventos'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
      floatingActionButton: _index == 0
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
          ? FloatingActionButton(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              onPressed: () => Navigator.pushNamed(context, '/novo-evento'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
<<<<<<< HEAD

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final String message;

  const _PlaceholderPage({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(message, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}

class _PerfilPage extends StatelessWidget {
  final String nome;
  final String email;
  final VoidCallback onLogout;

  const _PerfilPage({
    required this.nome,
    required this.email,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perfil',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
              title: Text(nome),
              subtitle: Text(email),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
=======
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
