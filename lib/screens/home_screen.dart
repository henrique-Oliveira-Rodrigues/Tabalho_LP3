import 'package:flutter/material.dart';
import '../data/mock_events.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({super.key, this.title = 'Descobrir Eventos'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = mockEvents.where((event) => event.titulo.toLowerCase().contains(search.toLowerCase())).toList();

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
                  Text(widget.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
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
                        onPressed: () => Navigator.pushNamed(context, '/filtros'),
                        icon: const Icon(Icons.tune),
                        style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100, foregroundColor: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  final evento = filtered[index];
                  return EventCard(
                    evento: evento,
                    onTap: () => Navigator.pushNamed(context, '/evento/${evento.id}'),
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
