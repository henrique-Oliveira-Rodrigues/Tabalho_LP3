import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
import '../models/evento.dart';

class EventCard extends StatelessWidget {
  final Evento evento;
  final VoidCallback onTap;

  const EventCard({
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
              height: 160,
              width: double.infinity,
              child: ColorFiltered(
<<<<<<< HEAD
                // Matriz para deixar a imagem com aparência monocromática,
                // mantendo a identidade visual preto/branco do protótipo.
=======
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
                colorFilter: const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0, 0, 0, 0.85, 0,
                ]),
<<<<<<< HEAD
                child: evento.imagemUrl.isEmpty
                    ? Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported_outlined),
                      )
                    : Image.network(
                        evento.imagemUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported_outlined),
                        ),
                      ),
=======
                child: Image.network(
                  evento.imagemUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
              ),
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
<<<<<<< HEAD
                  _InfoLine(
                    icon: Icons.calendar_month_outlined,
                    text: '${evento.data} • ${evento.horario}',
                  ),
                  const SizedBox(height: 6),
                  _InfoLine(
                    icon: Icons.location_on_outlined,
                    text: '${evento.local} - ${evento.bairro}',
                  ),
=======
                  _InfoLine(icon: Icons.calendar_month_outlined, text: evento.data),
                  const SizedBox(height: 6),
                  _InfoLine(icon: Icons.location_on_outlined, text: evento.local),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (evento.gratuito) const _Tag(text: 'Gratuito', outlined: true),
<<<<<<< HEAD
                      if (evento.inscricoesAbertas)
                        const _Tag(text: 'Inscrições abertas', outlined: false),
=======
                      if (evento.inscricoesAbertas) const _Tag(text: 'Inscrições abertas', outlined: false),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
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

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Expanded(
<<<<<<< HEAD
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
=======
          child: Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final bool outlined;

  const _Tag({required this.text, required this.outlined});

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
