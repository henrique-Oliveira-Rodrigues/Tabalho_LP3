import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  bool carregando = false;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> cadastrarUsuario() async {
    if (senhaController.text != confirmarSenhaController.text) {
      mostrarMensagem('As senhas não conferem.');
      return;
    }

    setState(() => carregando = true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text,
      );

      await credential.user?.updateDisplayName(nomeController.text.trim());

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/lista', (_) => false);
      }
    } on FirebaseAuthException catch (e) {
      mostrarMensagem(e.message ?? 'Não foi possível criar a conta.');
    } catch (_) {
      mostrarMensagem('Erro inesperado ao criar a conta.');
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  void mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

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
                  _Campo(label: 'Nome', hint: 'Seu nome completo', controller: nomeController),
                  const SizedBox(height: 18),
                  _Campo(label: 'Email', hint: 'seu@email.com', controller: emailController, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 18),
                  _Campo(label: 'Senha', hint: '••••••••', controller: senhaController, obscure: true),
                  const SizedBox(height: 18),
                  _Campo(label: 'Confirmar senha', hint: '••••••••', controller: confirmarSenhaController, obscure: true),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: carregando ? null : cadastrarUsuario,
                    child: Text(carregando ? 'Cadastrando...' : 'Cadastrar'),
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

class _Campo extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;

  const _Campo({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
