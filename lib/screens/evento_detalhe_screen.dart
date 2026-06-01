import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../services/evento_service.dart';

/// Tela de detalhes do evento.
///
/// Esta tela aplica as regras de negócio:
/// - o criador do evento pode editar e excluir;
/// - cliente comum pode se inscrever e cancelar inscrição;
/// - empresa que não criou o evento apenas visualiza;
/// - o criador não pode se inscrever no próprio evento.
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
  final EventoService eventoService = EventoService();

  Evento? evento;

  bool carregando = true;
  bool processandoAcao = false;
  bool ehEmpresa = false;
  bool inscrito = false;
  bool favorito = false;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  /// Carrega o evento, verifica se o usuário é empresa
  /// e verifica se o usuário atual já está inscrito.
  Future<void> carregarDados() async {
    setState(() => carregando = true);

    try {
      final eventoCarregado =
          await eventoService.buscarEventoPorId(widget.eventoId);

      final empresa = await eventoService.usuarioAtualEhEmpresa();

      final usuario = FirebaseAuth.instance.currentUser;

      bool jaInscrito = false;
      bool jaFavoritado = false;

      if (usuario != null) {
        jaInscrito = await eventoService.usuarioEstaInscrito(
          eventoId: widget.eventoId,
          usuarioId: usuario.uid,
        );

        jaFavoritado = await eventoService.usuarioFavoritouEvento(
          eventoId: widget.eventoId,
          usuarioId: usuario.uid,
        );
      }

      if (!mounted) return;

      setState(() {
        evento = eventoCarregado;
        ehEmpresa = empresa;
        inscrito = jaInscrito;
        favorito = jaFavoritado;
        carregando = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => carregando = false);
      mostrarMensagem('Erro ao carregar detalhes do evento.');
    }
  }

  /// Mostra mensagens simples para erros e confirmações.
  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  /// Retorna verdadeiro quando o usuário logado é o criador do evento.
  bool usuarioPodeGerenciar(Evento eventoAtual) {
    final usuario = FirebaseAuth.instance.currentUser;
    return usuario != null && usuario.uid == eventoAtual.criadoPor;
  }

  /// Abre a tela de edição e recarrega os dados ao voltar.
  Future<void> editarEvento(Evento eventoAtual) async {
    await Navigator.pushNamed(context, '/editar-evento/${eventoAtual.id}');
    await carregarDados();
  }

  /// Exclui o evento após confirmação.
  Future<void> excluirEvento(Evento eventoAtual) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir evento'),
          content: const Text(
            'Tem certeza que deseja excluir este evento? Essa ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmou != true) return;

    setState(() => processandoAcao = true);

    try {
      await eventoService.excluirEvento(eventoAtual.id);

      if (!mounted) return;

      mostrarMensagem('Evento excluído com sucesso.');
      Navigator.pop(context);
    } catch (e) {
      mostrarMensagem(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => processandoAcao = false);
      }
    }
  }

  /// Inscreve o cliente no evento.
  ///
  /// Regra:
  /// - usuário precisa estar logado;
  /// - inscrições precisam estar abertas;
  /// - criador do evento não pode se inscrever;
  /// - empresa não deve se inscrever como cliente.
  Future<void> inscrever(Evento eventoAtual) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      mostrarMensagem('Você precisa estar logado para se inscrever.');
      return;
    }

    if (ehEmpresa) {
      mostrarMensagem('Conta empresa não pode se inscrever como cliente.');
      return;
    }

    if (usuarioPodeGerenciar(eventoAtual)) {
      mostrarMensagem('Você é o organizador deste evento.');
      return;
    }

    if (!eventoAtual.inscricoesAbertas) {
      mostrarMensagem('As inscrições deste evento estão encerradas.');
      return;
    }

    setState(() => processandoAcao = true);

    try {
      await eventoService.inscreverUsuario(
        eventoId: eventoAtual.id,
        usuarioId: usuario.uid,
      );

      if (!mounted) return;

      setState(() => inscrito = true);
      mostrarMensagem('Inscrição realizada com sucesso!');
    } catch (e) {
      mostrarMensagem(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => processandoAcao = false);
      }
    }
  }

  /// Cancela a inscrição do cliente no evento.
  ///
  /// Esse método permite que o botão mude de "Inscrever-se" para
  /// "Cancelar inscrição" quando o usuário já está inscrito.
  Future<void> cancelarInscricao(Evento eventoAtual) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      mostrarMensagem('Você precisa estar logado para cancelar inscrição.');
      return;
    }

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar inscrição'),
          content: const Text(
            'Tem certeza que deseja cancelar sua inscrição neste evento?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sim, cancelar'),
            ),
          ],
        );
      },
    );

    if (confirmou != true) return;

    setState(() => processandoAcao = true);

    try {
      await eventoService.cancelarInscricao(
        eventoId: eventoAtual.id,
        usuarioId: usuario.uid,
      );

      if (!mounted) return;

      setState(() => inscrito = false);
      mostrarMensagem('Inscrição cancelada com sucesso.');
    } catch (e) {
      mostrarMensagem(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => processandoAcao = false);
      }
    }
  }

  /// Decide qual ação executar no botão principal:
  /// - se ainda não está inscrito, inscreve;
  /// - se já está inscrito, cancela inscrição.
  Future<void> alternarInscricao(Evento eventoAtual) async {
    if (inscrito) {
      await cancelarInscricao(eventoAtual);
    } else {
      await inscrever(eventoAtual);
    }
  }

  /// Alterna o evento entre favoritado e não favoritado.
  ///
  /// Essa ação é independente da inscrição: o usuário pode apenas salvar
  /// o evento como favorito para consultar depois na aba Favoritos.
  Future<void> alternarFavorito(Evento eventoAtual) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      mostrarMensagem('Você precisa estar logado para favoritar eventos.');
      return;
    }

    setState(() => processandoAcao = true);

    try {
      if (favorito) {
        await eventoService.removerFavorito(
          eventoId: eventoAtual.id,
          usuarioId: usuario.uid,
        );

        if (!mounted) return;

        setState(() => favorito = false);
        mostrarMensagem('Evento removido dos favoritos.');
      } else {
        await eventoService.favoritarEvento(
          eventoId: eventoAtual.id,
          usuarioId: usuario.uid,
        );

        if (!mounted) return;

        setState(() => favorito = true);
        mostrarMensagem('Evento adicionado aos favoritos.');
      }
    } catch (e) {
      mostrarMensagem(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => processandoAcao = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final eventoAtual = evento;

    if (eventoAtual == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Evento')),
        body: const Center(child: Text('Evento não encontrado.')),
      );
    }

    final podeGerenciar = usuarioPodeGerenciar(eventoAtual);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do evento'),
        actions: [
          // Botão de favorito aparece para usuários logados que não são o criador.
          // O favorito é pessoal do usuário e aparece na aba Favoritos.
          if (FirebaseAuth.instance.currentUser != null && !podeGerenciar)
            IconButton(
              tooltip: favorito ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
              icon: Icon(favorito ? Icons.favorite : Icons.favorite_border),
              onPressed:
                  processandoAcao ? null : () => alternarFavorito(eventoAtual),
            ),

          // Botões de CRUD aparecem apenas para o criador do evento.
          if (podeGerenciar)
            IconButton(
              tooltip: 'Editar evento',
              icon: const Icon(Icons.edit_outlined),
              onPressed:
                  processandoAcao ? null : () => editarEvento(eventoAtual),
            ),
          if (podeGerenciar)
            IconButton(
              tooltip: 'Excluir evento',
              icon: const Icon(Icons.delete_outline),
              onPressed:
                  processandoAcao ? null : () => excluirEvento(eventoAtual),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (eventoAtual.imagemUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      eventoAtual.imagemUrl,
                      height: 190,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  eventoAtual.titulo,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  eventoAtual.descricao,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                _DetailLine(
                  icon: Icons.calendar_month_outlined,
                  title: 'Data e horário',
                  value: '${eventoAtual.data} às ${eventoAtual.horario}',
                ),
                _DetailLine(
                  icon: Icons.location_on_outlined,
                  title: 'Local',
                  value: '${eventoAtual.local} - ${eventoAtual.bairro}',
                ),
                _DetailLine(
                  icon: Icons.attach_money,
                  title: 'Custo',
                  value: eventoAtual.gratuito ? 'Gratuito' : 'Pago',
                ),
                _DetailLine(
                  icon: Icons.how_to_reg_outlined,
                  title: 'Inscrições',
                  value: eventoAtual.inscricoesAbertas
                      ? 'Abertas'
                      : 'Encerradas',
                ),
                const SizedBox(height: 28),

                // Cliente comum pode se inscrever ou cancelar inscrição.
                if (!ehEmpresa && !podeGerenciar)
                  ElevatedButton.icon(
                    onPressed: processandoAcao ||
                            (!inscrito && !eventoAtual.inscricoesAbertas)
                        ? null
                        : () => alternarInscricao(eventoAtual),
                    icon: Icon(
                      inscrito ? Icons.cancel_outlined : Icons.how_to_reg,
                    ),
                    label: Text(
                      processandoAcao
                          ? 'Processando...'
                          : inscrito
                              ? 'Cancelar inscrição'
                              : eventoAtual.inscricoesAbertas
                                  ? 'Inscrever-se'
                                  : 'Inscrições encerradas',
                    ),
                  ),

                // Empresa que não criou o evento apenas visualiza.
                if (ehEmpresa && !podeGerenciar)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Conta empresa pode visualizar este evento, mas não pode se inscrever como cliente.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                // Criador do evento pode editar e excluir.
                if (podeGerenciar)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: processandoAcao
                              ? null
                              : () => editarEvento(eventoAtual),
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Editar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: processandoAcao
                              ? null
                              : () => excluirEvento(eventoAtual),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Excluir'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Linha visual para exibir uma informação do evento.
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
