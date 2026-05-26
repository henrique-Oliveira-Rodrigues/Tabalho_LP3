import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'modelo_evento.dart';
import 'widgets.dart';

class CriarEventoPage extends StatefulWidget {
  const CriarEventoPage({super.key});

  @override
  State<CriarEventoPage> createState() => _CriarEventoPageState();
}

class _CriarEventoPageState extends State<CriarEventoPage> {
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  final dataController = TextEditingController();
  final horarioController = TextEditingController();
  final localController = TextEditingController();
  final bairroController = TextEditingController();
  final linkController = TextEditingController();
  final imagemController = TextEditingController();

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
    linkController.dispose();
    imagemController.dispose();
    super.dispose();
  }

  Future<void> salvarEvento() async {
    if (tituloController.text.trim().isEmpty || dataController.text.trim().isEmpty || localController.text.trim().isEmpty) {
      mostrarMensagem('Preencha pelo menos título, data e local.');
      return;
    }

    setState(() => carregando = true);

    try {
      final usuario = FirebaseAuth.instance.currentUser;

      final evento = Evento(
        id: '',
        titulo: tituloController.text.trim(),
        descricao: descricaoController.text.trim(),
        data: dataController.text.trim(),
        horario: horarioController.text.trim(),
        local: localController.text.trim(),
        bairro: bairroController.text.trim(),
        linkInscricao: linkController.text.trim(),
        imagemUrl: imagemController.text.trim(),
        gratuito: gratuito,
        inscricoesAbertas: inscricoesAbertas,
        uid: usuario?.uid,
      );

      await FirebaseFirestore.instance.collection('eventos').add(evento.toMap());

      if (mounted) {
        mostrarMensagem('Evento cadastrado com sucesso.');
        Navigator.pop(context);
      }
    } catch (_) {
      mostrarMensagem('Não foi possível cadastrar o evento.');
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
        title: const Text('Novo Evento', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _Campo(label: 'Título do Evento', hint: 'Ex: Workshop de Fotografia', controller: tituloController),
                  const SizedBox(height: 18),
                  _Campo(label: 'Descrição', hint: 'Conte mais sobre o evento...', controller: descricaoController, maxLines: 4),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _Campo(label: 'Data', hint: 'dd/mm/aaaa', controller: dataController)),
                      const SizedBox(width: 14),
                      Expanded(child: _Campo(label: 'Horário', hint: '00:00', controller: horarioController)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _Campo(label: 'Local', hint: 'Ex: Praça Central', controller: localController),
                  const SizedBox(height: 18),
                  _Campo(label: 'Bairro', hint: 'Ex: Centro', controller: bairroController),
                  const SizedBox(height: 18),
                  _Campo(label: 'Link de inscrição', hint: 'https://...', controller: linkController, keyboardType: TextInputType.url),
                  const SizedBox(height: 18),
                  _Campo(label: 'Imagem do evento', hint: 'URL da imagem', controller: imagemController, keyboardType: TextInputType.url),
                  const SizedBox(height: 24),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 18),
                  _ToggleLinha(
                    title: 'Gratuito',
                    subtitle: 'O evento não tem custo',
                    value: gratuito,
                    onChanged: (value) => setState(() => gratuito = value),
                  ),
                  const SizedBox(height: 22),
                  _ToggleLinha(
                    title: 'Inscrições abertas',
                    subtitle: 'Permitir inscrições agora',
                    value: inscricoesAbertas,
                    onChanged: (value) => setState(() => inscricoesAbertas = value),
                  ),
                  const SizedBox(height: 34),
                  ElevatedButton(
                    onPressed: carregando ? null : salvarEvento,
                    child: Text(carregando ? 'Salvando...' : 'Salvar'),
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
  final int maxLines;
  final TextInputType? keyboardType;

  const _Campo({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
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
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _ToggleLinha extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleLinha({
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
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
        IosToggle(value: value, onChanged: onChanged),
      ],
    );
  }
}
