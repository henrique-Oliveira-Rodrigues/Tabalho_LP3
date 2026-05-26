<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool carregando = false;
  bool mostrarSenha = false;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> criarConta() async {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text;
    final confirmarSenha = confirmarSenhaController.text;

    // Validações locais antes de criar a conta no Firebase.
    if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmarSenha.isEmpty) {
      mostrarMensagem('Preencha todos os campos.');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      mostrarMensagem('Digite um email válido.');
      return;
    }

    if (senha.length < 6) {
      mostrarMensagem('A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    if (senha != confirmarSenha) {
      mostrarMensagem('As senhas não conferem.');
      return;
    }

    setState(() => carregando = true);

    try {
      // Cria usuário real no Firebase Authentication.
      final credencial = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Salva o nome no perfil do usuário autenticado.
      await credencial.user?.updateDisplayName(nome);

      if (!mounted) return;

      mostrarMensagem('Conta criada com sucesso!');
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          mostrarMensagem('Este email já está cadastrado.');
          break;
        case 'invalid-email':
          mostrarMensagem('Digite um email válido.');
          break;
        case 'weak-password':
          mostrarMensagem('A senha é muito fraca.');
          break;
        default:
          mostrarMensagem('Não foi possível criar a conta.');
      }
    } catch (_) {
      mostrarMensagem('Erro inesperado ao criar conta.');
    } finally {
      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criar conta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
=======
import 'package:flutter/material.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
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
<<<<<<< HEAD
                  Text(
                    'Preencha seus dados para começar a explorar eventos na sua região.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),
                  _FormField(
                    controller: nomeController,
                    label: 'Nome',
                    hint: 'Seu nome completo',
                  ),
                  const SizedBox(height: 18),
                  _FormField(
                    controller: emailController,
                    label: 'Email',
                    hint: 'seu@email.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18),
                  _FormField(
                    controller: senhaController,
                    label: 'Senha',
                    hint: '••••••••',
                    obscure: !mostrarSenha,
                  ),
                  const SizedBox(height: 18),
                  _FormField(
                    controller: confirmarSenhaController,
                    label: 'Confirmar senha',
                    hint: '••••••••',
                    obscure: !mostrarSenha,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: mostrarSenha,
                        onChanged: (value) {
                          setState(() => mostrarSenha = value ?? false);
                        },
                      ),
                      const Text('Mostrar senha'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: carregando ? null : criarConta,
                    child: Text(carregando ? 'Cadastrando...' : 'Cadastrar'),
=======
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
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
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
<<<<<<< HEAD
  final TextEditingController controller;
=======
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
  final String label;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;

<<<<<<< HEAD
  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
  });
=======
  const _FormField({required this.label, required this.hint, this.obscure = false, this.keyboardType});
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
<<<<<<< HEAD
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
        ),
=======
        TextField(obscureText: obscure, keyboardType: keyboardType, decoration: InputDecoration(hintText: hint)),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
      ],
    );
  }
}
