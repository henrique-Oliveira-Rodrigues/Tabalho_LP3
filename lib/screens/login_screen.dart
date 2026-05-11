import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(18)),
                    child: const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 34),
                  ),
                  const SizedBox(height: 16),
                  const Text('Bem-vindo de volta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Entre para encontrar eventos perto de você',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 56),
                  const _Label('Email'),
                  const TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(hintText: 'seu@email.com')),
                  const SizedBox(height: 20),
                  const _Label('Senha'),
                  const TextField(obscureText: true, decoration: InputDecoration(hintText: '••••••••')),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    child: const Text('Entrar'),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/cadastro'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: const BorderSide(color: Colors.black, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Criar conta', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
