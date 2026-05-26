import 'package:flutter/material.dart';
<<<<<<< HEAD

import '../models/evento.dart';
import '../services/evento_service.dart';
import '../widgets/event_card.dart';
import 'filtros_screen.dart';

class HomeScreen extends StatefulWidget {
  final String title;

=======
import '../data/mock_events.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  final String title;
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
  const HomeScreen({super.key, this.title = 'Descobrir Eventos'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
<<<<<<< HEAD
  final EventoService eventoService = EventoService();
  String search = '';
  FiltrosEventos? filtros;

  Future<void> abrirFiltros() async {
    // Abre a tela de filtros e aguarda o retorno dos dados escolhidos.
    final resultado = await Navigator.pushNamed(context, '/filtros');

    if (resultado is FiltrosEventos) {
      setState(() => filtros = resultado);
    }
  }

  List<Evento> aplicarBuscaEFiltros(List<Evento> eventos) {
    final textoBusca = search.toLowerCase().trim();

    return eventos.where((evento) {
      final combinaBusca = textoBusca.isEmpty ||
          evento.titulo.toLowerCase().contains(textoBusca) ||
          evento.local.toLowerCase().contains(textoBusca) ||
          evento.bairro.toLowerCase().contains(textoBusca);

      final filtroGratuito = filtros?.gratuito == true ? evento.gratuito : true;
      final filtroInscricoes = filtros?.inscricoesAbertas == true
          ? evento.inscricoesAbertas
          : true;
      final filtroBairro = filtros?.bairro != null ? evento.bairro == filtros!.bairro : true;

      return combinaBusca && filtroGratuito && filtroInscricoes && filtroBairro;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
=======
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = mockEvents.where((event) => event.titulo.toLowerCase().contains(search.toLowerCase())).toList();

>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
    return Container(
      color: Colors.grey.shade50,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
<<<<<<< HEAD
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
=======
                  Text(widget.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) => setState(() => search = value),
                          decoration: InputDecoration(
                            hintText: 'Buscar eventos...',
                            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade100),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filledTonal(
<<<<<<< HEAD
                        onPressed: abrirFiltros,
                        icon: const Icon(Icons.tune),
                        style: IconButton.styleFrom(
                          backgroundColor: filtros?.possuiFiltroAtivo == true
                              ? Colors.black
                              : Colors.grey.shade100,
                          foregroundColor: filtros?.possuiFiltroAtivo == true
                              ? Colors.white
                              : Colors.black,
                        ),
=======
                        onPressed: () => Navigator.pushNamed(context, '/filtros'),
                        icon: const Icon(Icons.tune),
                        style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100, foregroundColor: Colors.black),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
<<<<<<< HEAD
              // StreamBuilder escuta a coleção eventos em tempo real.
              child: StreamBuilder<List<Evento>>(
                stream: eventoService.listarEventos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar eventos.'),
                    );
                  }

                  final eventos = aplicarBuscaEFiltros(snapshot.data ?? []);

                  if (eventos.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Nenhum evento encontrado. Cadastre um novo evento no botão +.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: eventos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      final evento = eventos[index];

                      return EventCard(
                        evento: evento,
                        onTap: () => Navigator.pushNamed(context, '/evento/${evento.id}'),
                      );
                    },
=======
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  final evento = filtered[index];
                  return EventCard(
                    evento: evento,
                    onTap: () => Navigator.pushNamed(context, '/evento/${evento.id}'),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
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
