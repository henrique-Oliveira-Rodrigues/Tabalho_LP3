import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers capturam os valores digitados nos campos.
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool carregando = false;
  bool mostrarSenha = false;

  @override
  void dispose() {
    // Dispose evita vazamento de memória quando a tela é removida.
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> fazerLogin() async {
    final email = emailController.text.trim();
    final senha = senhaController.text;

    // Validação local: evita chamar o Firebase com campos claramente inválidos.
    if (email.isEmpty || senha.isEmpty) {
      mostrarMensagem('Preencha o email e a senha.');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      mostrarMensagem('Digite um email válido.');
      return;
    }

    setState(() => carregando = true);

    try {
      // Validação real: o Firebase verifica se o email existe e se a senha confere.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      if (!mounted) return;

      // Remove o histórico para o usuário não voltar para o login pelo botão voltar.
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } on FirebaseAuthException catch (e) {
      // Tratamento dos principais erros do Firebase em português.
      switch (e.code) {
        case 'invalid-email':
          mostrarMensagem('Digite um email válido.');
          break;
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          mostrarMensagem('Email ou senha inválidos.');
          break;
        case 'user-disabled':
          mostrarMensagem('Este usuário foi desativado.');
          break;
        case 'too-many-requests':
          mostrarMensagem('Muitas tentativas. Tente novamente mais tarde.');
          break;
        default:
          mostrarMensagem('Não foi possível fazer login.');
      }
    } catch (_) {
      mostrarMensagem('Erro inesperado ao fazer login.');
    } finally {
      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Bem-vindo de volta',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Entre para encontrar eventos perto de você',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 56),
                  const _Label('Email'),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'seu@email.com'),
                  ),
                  const SizedBox(height: 20),
                  const _Label('Senha'),
                  TextField(
                    controller: senhaController,
                    obscureText: !mostrarSenha,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => mostrarSenha = !mostrarSenha);
                        },
                        icon: Icon(
                          mostrarSenha ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: carregando ? null : fazerLogin,
                    child: Text(carregando ? 'Entrando...' : 'Entrar'),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: carregando
                        ? null
                        : () => Navigator.pushNamed(context, '/cadastro'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: const BorderSide(color: Colors.black, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Criar conta',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
