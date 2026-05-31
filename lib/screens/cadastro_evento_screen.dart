import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../services/evento_service.dart';

/// Tela de detalhes de um evento.
///
/// Nesta tela o usuário pode:
/// - visualizar as informações completas do evento;
/// - se inscrever, caso seja cliente;
/// - cancelar inscrição, caso já esteja inscrito;
/// - editar/excluir, caso seja o criador do evento.
class EventoDetalheScreen extends StatefulWidget {
  final String eventoId;

  const EventoDetalheScreen({
    super.key,
    required this.eventoId,
  });

  @override
  State<EventoDetalheScreen> createState() => _EventoDetalheScreenState();
}

class _EventoDetalheScreenState extends State<EventoDetalheScreen> {
  /// Serviço responsável pelas operações com eventos e inscrições no Firestore.
  final EventoService eventoService = EventoService();

  /// Evento carregado do Firestore.
  Evento? evento;

  /// Controla se a tela está carregando o evento.
  bool carregandoEvento = true;

  /// Controla se o botão de inscrição/cancelamento está processando.
  bool carregandoInscricao = false;

  /// Indica se o usuário atual já está inscrito no evento.
  bool usuarioInscrito = false;

  @override
  void initState() {
    super.initState();
    carregarEvento();
  }

  /// Mostra mensagens rápidas para o usuário.
  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  /// Carrega o evento pelo ID recebido na rota.
  ///
  /// Depois de carregar o evento, também verifica se o usuário atual
  /// já está inscrito nele.
  Future<void> carregarEvento() async {
    setState(() => carregandoEvento = true);

    try {
      final eventoEncontrado =
          await eventoService.buscarEventoPorId(widget.eventoId);

      if (!mounted) return;

      if (eventoEncontrado == null) {
        mostrarMensagem('Evento não encontrado.');
        Navigator.pop(context);
        return;
      }

      setState(() {
        evento = eventoEncontrado;
      });

      await verificarInscricao(eventoEncontrado.id);
    } catch (_) {
      if (!mounted) return;

      mostrarMensagem('Erro ao carregar evento.');
      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() => carregandoEvento = false);
      }
    }
  }

  /// Verifica se o usuário logado já está inscrito no evento.
  ///
  /// Essa verificação é usada para decidir se o botão deve mostrar:
  /// - "Inscrever-se"
  /// - ou "Cancelar inscrição"
  Future<void> verificarInscricao(String eventoId) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return;
    }

    final inscrito = await eventoService.usuarioEstaInscrito(
      eventoId: eventoId,
      usuarioId: usuario.uid,
    );

    if (!mounted) return;

    setState(() {
      usuarioInscrito = inscrito;
    });
  }

  /// Alterna entre inscrição e cancelamento de inscrição.
  ///
  /// Se o cliente ainda não está inscrito, realiza a inscrição.
  /// Se já está inscrito, cancela a inscrição.
  Future<void> alternarInscricao() async {
    final usuario = FirebaseAuth.instance.currentUser;
    final eventoAtual = evento;

    if (usuario == null) {
      mostrarMensagem('Você precisa estar logado para se inscrever.');
      return;
    }

    if (eventoAtual == null) {
      mostrarMensagem('Evento não encontrado.');
      return;
    }

    if (!eventoAtual.inscricoesAbertas) {
      mostrarMensagem('As inscrições deste evento estão fechadas.');
      return;
    }

    /// Regra de negócio:
    /// o criador/organizador do evento não deve se inscrever no próprio evento.
    if (eventoAtual.criadoPor == usuario.uid) {
      mostrarMensagem('Você é o organizador deste evento.');
      return;
    }

    setState(() => carregandoInscricao = true);

    try {
      if (usuarioInscrito) {
        await eventoService.cancelarInscricao(
          eventoId: eventoAtual.id,
          usuarioId: usuario.uid,
        );

        if (!mounted) return;

        setState(() {
          usuarioInscrito = false;
        });

        mostrarMensagem('Inscrição cancelada com sucesso.');
      } else {
        await eventoService.inscreverUsuario(
          eventoId: eventoAtual.id,
          usuarioId: usuario.uid,
        );

        if (!mounted) return;

        setState(() {
          usuarioInscrito = true;
        });

        mostrarMensagem('Inscrição realizada com sucesso.');
      }
    } catch (e) {
      mostrarMensagem(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => carregandoInscricao = false);
      }
    }
  }

  /// Exclui o evento.
  ///
  /// Apenas o criador do evento pode excluir.
  Future<void> excluirEvento() async {
    final usuario = FirebaseAuth.instance.currentUser;
    final eventoAtual = evento;

    if (usuario == null || eventoAtual == null) {
      mostrarMensagem('Não foi possível excluir o evento.');
      return;
    }

    if (eventoAtual.criadoPor != usuario.uid) {
      mostrarMensagem('Você só pode excluir eventos criados por você.');
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir evento'),
          content: const Text(
            'Tem certeza que deseja excluir este evento? '
            'Essa ação não poderá ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    try {
      await eventoService.excluirEvento(eventoAtual.id);

      if (!mounted) return;

      mostrarMensagem('Evento excluído com sucesso.');
      Navigator.pop(context);
    } catch (e) {
      mostrarMensagem(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Navega para a tela de edição do evento.
  void editarEvento() {
    final eventoAtual = evento;

    if (eventoAtual == null) {
      return;
    }

    Navigator.pushNamed(
      context,
      '/editar-evento/${eventoAtual.id}',
    ).then((_) {
      carregarEvento();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;

    if (carregandoEvento) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final eventoAtual = evento;

    if (eventoAtual == null) {
      return const Scaffold(
        body: Center(
          child: Text('Evento não encontrado.'),
        ),
      );
    }

    /// Verifica se o usuário atual é o criador/organizador do evento.
    final ehCriador =
        usuario != null && usuario.uid == eventoAtual.criadoPor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes do Evento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          /// Botões de edição/exclusão aparecem apenas para o criador.
          if (ehCriador) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar evento',
              onPressed: editarEvento,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Excluir evento',
              onPressed: excluirEvento,
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (eventoAtual.imagemUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      eventoAtual.imagemUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 220,
                          alignment: Alignment.center,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: 180,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.event,
                      size: 56,
                    ),
                  ),
                const SizedBox(height: 24),

                Text(
                  eventoAtual.titulo,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    if (eventoAtual.gratuito)
                      const _Tag(text: 'Gratuito'),
                    if (eventoAtual.gratuito) const SizedBox(width: 8),
                    if (eventoAtual.inscricoesAbertas)
                      const _Tag(text: 'Inscrições abertas'),
                    if (!eventoAtual.inscricoesAbertas)
                      const _Tag(text: 'Inscrições fechadas'),
                  ],
                ),
                const SizedBox(height: 24),

                _InfoLine(
                  icon: Icons.calendar_month,
                  label: 'Data',
                  value: eventoAtual.data,
                ),
                _InfoLine(
                  icon: Icons.access_time,
                  label: 'Horário',
                  value: eventoAtual.horario,
                ),
                _InfoLine(
                  icon: Icons.location_on,
                  label: 'Local',
                  value: eventoAtual.local,
                ),
                _InfoLine(
                  icon: Icons.map,
                  label: 'Bairro',
                  value: eventoAtual.bairro,
                ),

                const SizedBox(height: 28),
                const Text(
                  'Descrição',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  eventoAtual.descricao,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 32),

                /// Caso o usuário seja o criador, ele não precisa se inscrever.
                if (ehCriador)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Você é o organizador deste evento.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else if (!eventoAtual.inscricoesAbertas)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'As inscrições deste evento estão fechadas.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed:
                        carregandoInscricao ? null : alternarInscricao,
                    child: Text(
                      carregandoInscricao
                          ? 'Processando...'
                          : usuarioInscrito
                              ? 'Cancelar inscrição'
                              : 'Inscrever-se',
                    ),
                  ),

                if (eventoAtual.linkInscricao.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Link externo de inscrição: ${eventoAtual.linkInscricao}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Linha de informação usada na tela de detalhes.
class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tag visual usada para destacar informações do evento.
class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      side: BorderSide(color: Colors.grey.shade300),
    );
  }
}