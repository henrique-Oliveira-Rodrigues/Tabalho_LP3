import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../services/evento_service.dart';
import '../widgets/event_card.dart';

/// Tela responsável por listar os eventos favoritados pelo usuário atual.
///
/// A lista é alimentada pela coleção `favoritos` do Firestore.
/// Cada favorito aponta para um evento por meio do campo `eventoId`.
class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventoService = EventoService();

    return Container(
      color: Colors.grey.shade50,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favoritos',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Eventos que você salvou para consultar depois.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Evento>>(
                stream: eventoService.listarEventosFavoritosUsuarioAtual(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Erro ao carregar favoritos.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final eventos = snapshot.data ?? [];

                  if (eventos.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Você ainda não favoritou nenhum evento.\nAbra um evento e toque no coração para adicioná-lo aqui.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: eventos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final evento = eventos[index];

                      return EventCard(
                        evento: evento,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/evento/${evento.id}',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
