// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../models/evento.dart';
// import '../services/evento_service.dart';
// import '../widgets/ios_toggle.dart';

// class CadastroEventoScreen extends StatefulWidget {
//   const CadastroEventoScreen({super.key});

//   @override
//   State<CadastroEventoScreen> createState() => _CadastroEventoScreenState();
// }

// class _CadastroEventoScreenState extends State<CadastroEventoScreen> {
//   final EventoService eventoService = EventoService();

//   final tituloController = TextEditingController();
//   final descricaoController = TextEditingController();
//   final dataController = TextEditingController();
//   final horarioController = TextEditingController();
//   final localController = TextEditingController();
//   final bairroController = TextEditingController();
//   final linkInscricaoController = TextEditingController();
//   final imagemUrlController = TextEditingController();

//   bool gratuito = false;
//   bool inscricoesAbertas = true;
//   bool carregando = false;

//   @override
//   void dispose() {
//     tituloController.dispose();
//     descricaoController.dispose();
//     dataController.dispose();
//     horarioController.dispose();
//     localController.dispose();
//     bairroController.dispose();
//     linkInscricaoController.dispose();
//     imagemUrlController.dispose();
//     super.dispose();
//   }

//   void mostrarMensagem(String mensagem) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(mensagem)),
//     );
//   }

//   Future<void> salvarEvento() async {
//     final usuario = FirebaseAuth.instance.currentUser;

//     // Segurança básica: apenas usuário autenticado pode cadastrar evento.
//     if (usuario == null) {
//       mostrarMensagem('Você precisa estar logado para cadastrar um evento.');
//       return;
//     }

//     final titulo = tituloController.text.trim();
//     final descricao = descricaoController.text.trim();
//     final data = dataController.text.trim();
//     final horario = horarioController.text.trim();
//     final local = localController.text.trim();
//     final bairro = bairroController.text.trim();
//     final linkInscricao = linkInscricaoController.text.trim();
//     final imagemUrl = imagemUrlController.text.trim();

//     if (titulo.isEmpty ||
//         descricao.isEmpty ||
//         data.isEmpty ||
//         horario.isEmpty ||
//         local.isEmpty ||
//         bairro.isEmpty) {
//       mostrarMensagem('Preencha os campos obrigatórios.');
//       return;
//     }

//     setState(() => carregando = true);

//     try {
//       final evento = Evento(
//         id: '',
//         titulo: titulo,
//         descricao: descricao,
//         data: data,
//         horario: horario,
//         local: local,
//         bairro: bairro,
//         linkInscricao: linkInscricao,
//         imagemUrl: imagemUrl,
//         gratuito: gratuito,
//         inscricoesAbertas: inscricoesAbertas,
//         criadoPor: usuario.uid,
//       );

//       await eventoService.criarEvento(evento);

//       if (!mounted) return;

//       mostrarMensagem('Evento cadastrado com sucesso!');
//       Navigator.pop(context);
//     } catch (_) {
//       mostrarMensagem('Erro ao cadastrar evento.');
//     } finally {
//       if (mounted) {
//         setState(() => carregando = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Novo Evento',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: carregando ? null : () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 430),
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   _Field(
//                     controller: tituloController,
//                     label: 'Título do Evento *',
//                     hint: 'Ex: Workshop de Fotografia',
//                   ),
//                   const SizedBox(height: 18),
//                   _Field(
//                     controller: descricaoController,
//                     label: 'Descrição *',
//                     hint: 'Conte mais sobre o evento...',
//                     maxLines: 4,
//                   ),
//                   const SizedBox(height: 18),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _Field(
//                           controller: dataController,
//                           label: 'Data *',
//                           hint: 'dd/mm/aaaa',
//                           keyboardType: TextInputType.datetime,
//                         ),
//                       ),
//                       const SizedBox(width: 14),
//                       Expanded(
//                         child: _Field(
//                           controller: horarioController,
//                           label: 'Horário *',
//                           hint: '00:00',
//                           keyboardType: TextInputType.datetime,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 18),
//                   _Field(
//                     controller: localController,
//                     label: 'Local *',
//                     hint: 'Ex: Praça Central',
//                   ),
//                   const SizedBox(height: 18),
//                   _Field(
//                     controller: bairroController,
//                     label: 'Bairro *',
//                     hint: 'Ex: Centro',
//                   ),
//                   const SizedBox(height: 18),
//                   _Field(
//                     controller: linkInscricaoController,
//                     label: 'Link de Inscrição',
//                     hint: 'https://...',
//                     keyboardType: TextInputType.url,
//                   ),
//                   const SizedBox(height: 18),
//                   _Field(
//                     controller: imagemUrlController,
//                     label: 'Imagem do Evento',
//                     hint: 'URL da imagem, opcional',
//                     keyboardType: TextInputType.url,
//                   ),
//                   const SizedBox(height: 24),
//                   Divider(color: Colors.grey.shade300),
//                   const SizedBox(height: 18),
//                   _ToggleLine(
//                     title: 'Gratuito',
//                     subtitle: 'O evento não tem custo',
//                     value: gratuito,
//                     onChanged: (value) => setState(() => gratuito = value),
//                   ),
//                   const SizedBox(height: 22),
//                   _ToggleLine(
//                     title: 'Inscrições abertas',
//                     subtitle: 'Permitir inscrições agora',
//                     value: inscricoesAbertas,
//                     onChanged: (value) => setState(() => inscricoesAbertas = value),
//                   ),
//                   const SizedBox(height: 34),
//                   ElevatedButton(
//                     onPressed: carregando ? null : salvarEvento,
//                     child: Text(carregando ? 'Salvando...' : 'Salvar'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _Field extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final int maxLines;
//   final TextInputType? keyboardType;

//   const _Field({
//     required this.controller,
//     required this.label,
//     required this.hint,
//     this.maxLines = 1,
//     this.keyboardType,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//         const SizedBox(height: 6),
//         TextField(
//           controller: controller,
//           maxLines: maxLines,
//           keyboardType: keyboardType,
//           decoration: InputDecoration(hintText: hint),
//         ),
//       ],
//     );
//   }
// }

// class _ToggleLine extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final bool value;
//   final ValueChanged<bool> onChanged;

//   const _ToggleLine({
//     required this.title,
//     required this.subtitle,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 4),
//               Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
//             ],
//           ),
//         ),
//         IosToggle(value: value, onChanged: onChanged),
//       ],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../services/evento_service.dart';
import '../widgets/ios_toggle.dart';

class CadastroEventoScreen extends StatefulWidget {
  const CadastroEventoScreen({super.key});

  @override
  State<CadastroEventoScreen> createState() => _CadastroEventoScreenState();
}

class _CadastroEventoScreenState extends State<CadastroEventoScreen> {
  final EventoService eventoService = EventoService();

  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  final dataController = TextEditingController();
  final horarioController = TextEditingController();
  final localController = TextEditingController();
  final bairroController = TextEditingController();
  final linkInscricaoController = TextEditingController();
  final imagemUrlController = TextEditingController();

  bool gratuito = false;
  bool inscricoesAbertas = true;
  bool carregando = false;

  @override
  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    dataController.dispose();
    horarioController.dispose();
    localController.dispose();
    bairroController.dispose();
    linkInscricaoController.dispose();
    imagemUrlController.dispose();
    super.dispose();
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> salvarEvento() async {
    final usuario = FirebaseAuth.instance.currentUser;

    // Segurança básica: apenas usuário autenticado pode cadastrar evento.
    if (usuario == null) {
      mostrarMensagem(
        'Você precisa estar logado para cadastrar um evento.',
      );
      return;
    }

    // Verifica se o usuário é empresa.
    try {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.uid)
          .get();

      final ehEmpresa = doc.data()?['ehEmpresa'] ?? false;

      if (!ehEmpresa) {
        mostrarMensagem(
          'Apenas empresas podem cadastrar eventos.',
        );
        return;
      }
    } catch (_) {
      mostrarMensagem(
        'Não foi possível verificar as permissões do usuário.',
      );
      return;
    }

    final titulo = tituloController.text.trim();
    final descricao = descricaoController.text.trim();
    final data = dataController.text.trim();
    final horario = horarioController.text.trim();
    final local = localController.text.trim();
    final bairro = bairroController.text.trim();
    final linkInscricao = linkInscricaoController.text.trim();
    final imagemUrl = imagemUrlController.text.trim();

    if (titulo.isEmpty ||
        descricao.isEmpty ||
        data.isEmpty ||
        horario.isEmpty ||
        local.isEmpty ||
        bairro.isEmpty) {
      mostrarMensagem('Preencha os campos obrigatórios.');
      return;
    }

    setState(() => carregando = true);

    try {
      final evento = Evento(
        id: '',
        titulo: titulo,
        descricao: descricao,
        data: data,
        horario: horario,
        local: local,
        bairro: bairro,
        linkInscricao: linkInscricao,
        imagemUrl: imagemUrl,
        gratuito: gratuito,
        inscricoesAbertas: inscricoesAbertas,
        criadoPor: usuario.uid,
      );

      await eventoService.criarEvento(evento);

      if (!mounted) return;

      mostrarMensagem('Evento cadastrado com sucesso!');
      Navigator.pop(context);
    } catch (_) {
      mostrarMensagem('Erro ao cadastrar evento.');
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
          'Novo Evento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: carregando ? null : () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _Field(
                    controller: tituloController,
                    label: 'Título do Evento *',
                    hint: 'Ex: Workshop de Fotografia',
                  ),
                  const SizedBox(height: 18),
                  _Field(
                    controller: descricaoController,
                    label: 'Descrição *',
                    hint: 'Conte mais sobre o evento...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _Field(
                          controller: dataController,
                          label: 'Data *',
                          hint: 'dd/mm/aaaa',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _Field(
                          controller: horarioController,
                          label: 'Horário *',
                          hint: '00:00',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _Field(
                    controller: localController,
                    label: 'Local *',
                    hint: 'Ex: Praça Central',
                  ),
                  const SizedBox(height: 18),
                  _Field(
                    controller: bairroController,
                    label: 'Bairro *',
                    hint: 'Ex: Centro',
                  ),
                  const SizedBox(height: 18),
                  _Field(
                    controller: linkInscricaoController,
                    label: 'Link de Inscrição',
                    hint: 'https://...',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 18),
                  _Field(
                    controller: imagemUrlController,
                    label: 'Imagem do Evento',
                    hint: 'URL da imagem, opcional',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 18),
                  _ToggleLine(
                    title: 'Gratuito',
                    subtitle: 'O evento não tem custo',
                    value: gratuito,
                    onChanged: (value) => setState(() => gratuito = value),
                  ),
                  const SizedBox(height: 22),
                  _ToggleLine(
                    title: 'Inscrições abertas',
                    subtitle: 'Permitir inscrições agora',
                    value: inscricoesAbertas,
                    onChanged: (value) =>
                        setState(() => inscricoesAbertas = value),
                  ),
                  const SizedBox(height: 34),
                  ElevatedButton(
                    onPressed: carregando ? null : salvarEvento,
                    child: Text(
                      carregando ? 'Salvando...' : 'Salvar',
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

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }
}

class _ToggleLine extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleLine({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        IosToggle(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}