import 'package:flutter/material.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Preencha seus dados para começar a explorar eventos na sua região.', style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 32),
                  const _FormField(label: 'Nome', hint: 'Seu nome completo'),
                  const SizedBox(height: 18),
                  const _FormField(label: 'Email', hint: 'seu@email.com', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 18),
                  const _FormField(label: 'Senha', hint: '••••••••', obscure: true),
                  const SizedBox(height: 18),
                  const _FormField(label: 'Confirmar senha', hint: '••••••••', obscure: true),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('Cadastrar'),
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

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;

  const _FormField({required this.label, required this.hint, this.obscure = false, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(obscureText: obscure, keyboardType: keyboardType, decoration: InputDecoration(hintText: hint)),
      ],
    );
  }
}
