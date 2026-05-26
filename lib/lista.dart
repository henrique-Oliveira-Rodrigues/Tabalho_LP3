import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'modelo_evento.dart';
import 'widgets.dart';

class ListaEventosPage extends StatefulWidget {
  const ListaEventosPage({super.key});

  @override
  State<ListaEventosPage> createState() => _ListaEventosPageState();
}

class _ListaEventosPageState extends State<ListaEventosPage> {
  String busca = '';
  bool apenasGratuitos = false;
  bool apenasInscricoesAbertas = false;

  Stream<List<Evento>> get eventosStream {
    return FirebaseFirestore.instance
        .collection('eventos')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Evento.fromFirestore).toList());
  }

  Future<void> sair() async {
    await FirebaseAuth.instance.signOut();

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }

  List<Evento> aplicarFiltros(List<Evento> eventos) {
    return eventos.where((evento) {
      final textoBusca = busca.trim().toLowerCase();
      final combinaBusca = textoBusca.isEmpty ||
          evento.titulo.toLowerCase().contains(textoBusca) ||
          evento.local.toLowerCase().contains(textoBusca) ||
          evento.bairro.toLowerCase().contains(textoBusca);

      final combinaGratuito = !apenasGratuitos || evento.gratuito;
      final combinaInscricoes = !apenasInscricoesAbertas || evento.inscricoesAbertas;

      return combinaBusca && combinaGratuito && combinaInscricoes;
    }).toList();
  }

  Future<void> abrirFiltros() async {
    final resultado = await Navigator.pushNamed(
      context,
      '/filtros',
      arguments: {
        'gratuito': apenasGratuitos,
        'inscricoesAbertas': apenasInscricoesAbertas,
      },
    );

    if (resultado is Map) {
      setState(() {
        apenasGratuitos = resultado['gratuito'] == true;
        apenasInscricoesAbertas = resultado['inscricoesAbertas'] == true;
      });
    }
  }

  Future<void> criarEventosExemplo() async {
    final usuario = FirebaseAuth.instance.currentUser;
    final eventos = [
      const Evento(
        id: '',
        titulo: 'Feira de Artesanato Local',
        descricao: 'Evento comunitário com exposição de artesãos, produtos locais e atividades culturais.',
        data: '15/05/2026',
        horario: '10:00',
        local: 'Praça Central, Centro',
        bairro: 'Centro',
        linkInscricao: '',
        imagemUrl: 'https://images.unsplash.com/photo-1474625121024-7595bfbc57ac?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080',
        gratuito: true,
        inscricoesAbertas: true,
      ),
      const Evento(
        id: '',
        titulo: 'Workshop de Fotografia Mobile',
        descricao: 'Oficina para aprender técnicas básicas de fotografia usando celular.',
        data: '20/05/2026',
        horario: '14:00',
        local: 'Biblioteca Municipal',
        bairro: 'Centro',
        linkInscricao: '',
        imagemUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080',
        gratuito: false,
        inscricoesAbertas: true,
      ),
      const Evento(
        id: '',
        titulo: 'Festival de Comida de Rua',
        descricao: 'Festival gastronômico com food trucks e atrações musicais.',
        data: '22/05/2026',
        horario: '18:00',
        local: 'Parque da Cidade',
        bairro: 'Zona Sul',
        linkInscricao: '',
        imagemUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080',
        gratuito: true,
        inscricoesAbertas: false,
      ),
    ];

    for (final evento in eventos) {
      await FirebaseFirestore.instance.collection('eventos').add(
            Evento(
              id: evento.id,
              titulo: evento.titulo,
              descricao: evento.descricao,
              data: evento.data,
              horario: evento.horario,
              local: evento.local,
              bairro: evento.bairro,
              linkInscricao: evento.linkInscricao,
              imagemUrl: evento.imagemUrl,
              gratuito: evento.gratuito,
              inscricoesAbertas: evento.inscricoesAbertas,
              uid: usuario?.uid,
            ).toMap(),
          );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Eventos de exemplo criados.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Agenda Local', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: sair,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, ${usuario?.displayName?.isNotEmpty == true ? usuario!.displayName : 'usuário'}!',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) => setState(() => busca = value),
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
                          onPressed: abrirFiltros,
                          icon: const Icon(Icons.tune),
                          style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100, foregroundColor: Colors.black),
                        ),
                      ],
                    ),
                    if (apenasGratuitos || apenasInscricoesAbertas) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (apenasGratuitos) const TagAgenda(text: 'Gratuitos', outlined: true),
                          if (apenasInscricoesAbertas) const TagAgenda(text: 'Inscrições abertas', outlined: false),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Evento>>(
                  stream: eventosStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text('Erro ao carregar eventos: ${snapshot.error}', textAlign: TextAlign.center),
                        ),
                      );
                    }

                    final eventos = aplicarFiltros(snapshot.data ?? []);

                    if (eventos.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.event_busy, size: 56),
                              const SizedBox(height: 14),
                              const Text('Nenhum evento encontrado.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(
                                'Cadastre um novo evento ou crie alguns eventos de exemplo para testar a tela inicial.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 18),
                              ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/novo-evento'),
                                icon: const Icon(Icons.add),
                                label: const Text('Cadastrar evento'),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton.icon(
                                onPressed: criarEventosExemplo,
                                icon: const Icon(Icons.auto_awesome),
                                label: const Text('Criar exemplos'),
                              ),
                            ],
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
                        return EventoCard(
                          evento: evento,
                          onTap: () => Navigator.pushNamed(context, '/evento/${evento.id}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.pushNamed(context, '/novo-evento'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
