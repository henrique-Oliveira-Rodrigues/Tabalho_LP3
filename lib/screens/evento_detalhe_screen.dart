import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../services/evento_service.dart';

class EventoDetalheScreen extends StatelessWidget {
  final String eventoId;

  const EventoDetalheScreen({super.key, required this.eventoId});

  @override
  Widget build(BuildContext context) {
    final eventoService = EventoService();

    return FutureBuilder<Evento?>(
      // Busca o evento real no Firestore pelo ID recebido na rota.
      future: eventoService.buscarEventoPorId(eventoId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Erro ao carregar evento.')),
          );
        }

        final event = snapshot.data;

        if (event == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Evento não encontrado.')),
          );
        }

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
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.matrix(<double>[
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0, 0, 0, 0.9, 0,
                                    ]),
                                    child: event.imagemUrl.isEmpty
                                        ? Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.image_not_supported_outlined,
                                              size: 48,
                                            ),
                                          )
                                        : Image.network(
                                            event.imagemUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              color: Colors.grey.shade200,
                                              child: const Icon(
                                                Icons.image_not_supported_outlined,
                                                size: 48,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  top: 42,
                                  left: 16,
                                  right: 16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _CircleButton(
                                        icon: Icons.arrow_back,
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      Row(
                                        children: [
                                          _CircleButton(
                                            icon: Icons.share_outlined,
                                            onPressed: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Compartilhamento ainda não implementado.'),
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          _CircleButton(
                                            icon: Icons.favorite_border,
                                            onPressed: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Favoritos ainda não implementado.'),
                                                ),
                                              );
                                            },
                                          ),
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
                                      if (event.gratuito)
                                        const _SmallTag(text: 'Gratuito', outlined: true),
                                      if (event.inscricoesAbertas)
                                        const _SmallTag(
                                          text: 'Inscrições abertas',
                                          outlined: false,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    event.titulo,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      height: 1.15,
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  _DetailLine(
                                    icon: Icons.calendar_month_outlined,
                                    title: 'Data e Horário',
                                    value: '${event.data} • ${event.horario}',
                                  ),
                                  const SizedBox(height: 16),
                                  _DetailLine(
                                    icon: Icons.location_on_outlined,
                                    title: 'Local',
                                    value: '${event.local} - ${event.bairro}',
                                  ),
                                  const SizedBox(height: 24),
                                  Divider(color: Colors.grey.shade300),
                                  const SizedBox(height: 18),
                                  const Text(
                                    'Sobre o evento',
                                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    event.descricao,
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
                        onPressed: event.linkInscricao.isEmpty
                            ? null
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Link de inscrição: ${event.linkInscricao}'),
                                  ),
                                );
                              },
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

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _CircleButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      style: IconButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.28)),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailLine({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(value, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallTag extends StatelessWidget {
  final String text;
  final bool outlined;
  const _SmallTag({required this.text, required this.outlined});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: outlined ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(6),
        border: outlined ? Border.all(color: Colors.black) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: outlined ? Colors.black : Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
