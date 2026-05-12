import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'modelo_evento.dart';
import 'widgets.dart';

class DetalhesEventoPage extends StatelessWidget {
  final String eventoId;

  const DetalhesEventoPage({super.key, required this.eventoId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('eventos').doc(eventoId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: const Text('Evento')),
            body: const Center(child: Text('Evento não encontrado.')),
          );
        }

        final evento = Evento.fromFirestore(snapshot.data!);

        return Scaffold(
          body: SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: 260,
                                  width: double.infinity,
                                  child: _ImagemTopo(imagemUrl: evento.imagemUrl),
                                ),
                                Positioned(
                                  top: 42,
                                  left: 16,
                                  right: 16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _CircleButton(icon: Icons.arrow_back, onPressed: () => Navigator.pop(context)),
                                      Row(
                                        children: [
                                          _CircleButton(icon: Icons.share_outlined, onPressed: () {}),
                                          const SizedBox(width: 8),
                                          _CircleButton(icon: Icons.favorite_border, onPressed: () {}),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      if (evento.gratuito) const TagAgenda(text: 'Gratuito', outlined: true),
                                      if (evento.inscricoesAbertas) const TagAgenda(text: 'Inscrições abertas', outlined: false),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(evento.titulo, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.15)),
                                  const SizedBox(height: 22),
                                  InfoLine(icon: Icons.calendar_month_outlined, text: '${evento.data} • ${evento.horario}'),
                                  const SizedBox(height: 16),
                                  InfoLine(icon: Icons.location_on_outlined, text: evento.local),
                                  if (evento.bairro.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    InfoLine(icon: Icons.map_outlined, text: evento.bairro),
                                  ],
                                  const SizedBox(height: 24),
                                  Divider(color: Colors.grey.shade300),
                                  const SizedBox(height: 18),
                                  const Text('Sobre o evento', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Text(
                                    evento.descricao.isEmpty ? 'Nenhuma descrição informada para este evento.' : evento.descricao,
                                    style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(evento.linkInscricao.isEmpty ? 'Link de inscrição não informado.' : evento.linkInscricao)),
                        ),
                        child: const Text('Ver inscrição'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ImagemTopo extends StatelessWidget {
  final String imagemUrl;

  const _ImagemTopo({required this.imagemUrl});

  @override
  Widget build(BuildContext context) {
    if (imagemUrl.trim().isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.event, size: 64),
      );
    }

    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0, 0, 0, 0.9, 0,
      ]),
      child: Image.network(
        imagemUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      style: IconButton.styleFrom(backgroundColor: Colors.black.withAlpha(72)),
    );
  }
}
