import 'package:flutter/material.dart';

import 'modelo_evento.dart';

class EventoCard extends StatelessWidget {
  final Evento evento;
  final VoidCallback onTap;

  const EventoCard({
    super.key,
    required this.evento,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: _ImagemEvento(imagemUrl: evento.imagemUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.titulo,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  InfoLine(icon: Icons.calendar_month_outlined, text: '${evento.data} • ${evento.horario}'),
                  const SizedBox(height: 6),
                  InfoLine(icon: Icons.location_on_outlined, text: evento.local),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (evento.gratuito) const TagAgenda(text: 'Gratuito', outlined: true),
                      if (evento.inscricoesAbertas) const TagAgenda(text: 'Inscrições abertas', outlined: false),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagemEvento extends StatelessWidget {
  final String imagemUrl;

  const _ImagemEvento({required this.imagemUrl});

  @override
  Widget build(BuildContext context) {
    if (imagemUrl.trim().isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.event, size: 52),
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
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_not_supported_outlined),
        ),
      ),
    );
  }
}

class InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoLine({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
        ),
      ],
    );
  }
}

class TagAgenda extends StatelessWidget {
  final String text;
  final bool outlined;

  const TagAgenda({super.key, required this.text, required this.outlined});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: outlined ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: outlined ? Border.all(color: Colors.black, width: 2) : null,
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

class IosToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const IosToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: value ? Colors.black : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 220),
          curve: Curves.elasticOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: value ? Colors.black : Colors.grey.shade300),
              boxShadow: const [
                BoxShadow(blurRadius: 2, offset: Offset(0, 1), color: Color(0x22000000)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
