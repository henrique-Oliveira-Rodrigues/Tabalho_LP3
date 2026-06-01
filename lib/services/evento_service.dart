import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/evento.dart';

/// Serviço responsável por centralizar toda comunicação com o Firestore.
///
/// Essa camada evita espalhar comandos como `FirebaseFirestore.instance` pelas
/// telas. Assim, as telas ficam focadas na interface e este serviço fica focado
/// nas operações de dados e regras de negócio do app.
class EventoService {
  /// Coleção principal onde os eventos são armazenados.
  final CollectionReference<Map<String, dynamic>> _eventosRef =
      FirebaseFirestore.instance.collection('eventos');

  /// Coleção usada para registrar inscrições de clientes em eventos.
  final CollectionReference<Map<String, dynamic>> _inscricoesRef =
      FirebaseFirestore.instance.collection('inscricoes');

  /// Coleção usada para registrar os eventos favoritos de cada usuário.
  ///
  /// Cada documento usa um ID determinístico no formato `eventoId_usuarioId`.
  /// Isso evita que o mesmo usuário favorite o mesmo evento mais de uma vez.
  final CollectionReference<Map<String, dynamic>> _favoritosRef =
      FirebaseFirestore.instance.collection('favoritos');

  /// Coleção de usuários. Ela guarda o campo `ehEmpresa`, usado para separar
  /// empresa/organizador de cliente comum.
  final CollectionReference<Map<String, dynamic>> _usuariosRef =
      FirebaseFirestore.instance.collection('usuarios');

  /// Retorna a lista de eventos em tempo real.
  ///
  /// `snapshots()` mantém a tela atualizada automaticamente quando algum
  /// evento é criado, editado ou excluído no Firestore.
  Stream<List<Evento>> listarEventos() {
    return _eventosRef
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Evento.fromFirestore).toList());
  }

  /// Busca um evento específico pelo ID do documento.
  Future<Evento?> buscarEventoPorId(String id) async {
    final doc = await _eventosRef.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return Evento.fromFirestore(doc);
  }

  /// Verifica se o usuário atual é uma empresa/organizador.
  ///
  /// Regra de negócio adotada:
  /// - `ehEmpresa == true`: pode cadastrar eventos;
  /// - `ehEmpresa == false`: cliente comum, apenas visualiza e se inscreve.
  Future<bool> usuarioAtualEhEmpresa() async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return false;
    }

    final doc = await _usuariosRef.doc(usuario.uid).get();
    return doc.data()?['ehEmpresa'] == true;
  }

  /// Cadastra um novo evento.
  ///
  /// A tela faz as validações do formulário, mas o service também valida
  /// a regra principal: somente empresa pode cadastrar evento.
  Future<void> criarEvento(Evento evento) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    final ehEmpresa = await usuarioAtualEhEmpresa();

    if (!ehEmpresa) {
      throw Exception('Apenas empresas podem cadastrar eventos.');
    }

    await _eventosRef.add(evento.toCreateMap());
  }

  /// Atualiza um evento existente.
  ///
  /// Regra de negócio:
  /// somente a empresa que criou o evento pode editar esse evento.
  Future<void> atualizarEvento(Evento evento) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    final eventoAtual = await buscarEventoPorId(evento.id);

    if (eventoAtual == null) {
      throw Exception('Evento não encontrado.');
    }

    if (eventoAtual.criadoPor != usuario.uid) {
      throw Exception('Você só pode editar eventos criados por você.');
    }

    await _eventosRef.doc(evento.id).update(evento.toUpdateMap());
  }

  /// Exclui um evento existente.
  ///
  /// Regra de negócio:
  /// somente a empresa que criou o evento pode excluir esse evento.
  Future<void> excluirEvento(String id) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    final eventoAtual = await buscarEventoPorId(id);

    if (eventoAtual == null) {
      throw Exception('Evento não encontrado.');
    }

    if (eventoAtual.criadoPor != usuario.uid) {
      throw Exception('Você só pode excluir eventos criados por você.');
    }

    await _eventosRef.doc(id).delete();

    // Remove inscrições e favoritos relacionados ao evento excluído para não
    // deixar documentos órfãos nas coleções secundárias.
    final inscricoes = await _inscricoesRef.where('eventoId', isEqualTo: id).get();
    final favoritos = await _favoritosRef.where('eventoId', isEqualTo: id).get();
    final batch = FirebaseFirestore.instance.batch();

    for (final inscricao in inscricoes.docs) {
      batch.delete(inscricao.reference);
    }

    for (final favorito in favoritos.docs) {
      batch.delete(favorito.reference);
    }

    await batch.commit();
  }

  /// Verifica se um usuário já está inscrito em determinado evento.
  ///
  /// Retorna true se existir uma inscrição com o mesmo `eventoId` e `usuarioId`.
  Future<bool> usuarioEstaInscrito({
    required String eventoId,
    required String usuarioId,
  }) async {
    final inscricaoId = _gerarInscricaoId(eventoId, usuarioId);
    final doc = await _inscricoesRef.doc(inscricaoId).get();

    return doc.exists;
  }

  /// Verifica se o usuário atual já está inscrito em determinado evento.
  Future<bool> usuarioAtualEstaInscrito(String eventoId) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return false;
    }

    return usuarioEstaInscrito(eventoId: eventoId, usuarioId: usuario.uid);
  }

  /// Realiza a inscrição de um cliente em um evento.
  ///
  /// Regra de negócio:
  /// - usuário precisa estar autenticado;
  /// - o `usuarioId` precisa ser do próprio usuário logado;
  /// - empresa/organizador não se inscreve como cliente;
  /// - o criador não pode se inscrever no próprio evento;
  /// - inscrições precisam estar abertas;
  /// - um usuário não pode se inscrever duas vezes no mesmo evento.
  Future<void> inscreverUsuario({
    required String eventoId,
    required String usuarioId,
  }) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Faça login para se inscrever.');
    }

    if (usuario.uid != usuarioId) {
      throw Exception('Você só pode realizar inscrição para sua própria conta.');
    }

    final ehEmpresa = await usuarioAtualEhEmpresa();

    if (ehEmpresa) {
      throw Exception('Conta empresarial gerencia eventos e não realiza inscrição.');
    }

    final evento = await buscarEventoPorId(eventoId);

    if (evento == null) {
      throw Exception('Evento não encontrado.');
    }

    if (evento.criadoPor == usuario.uid) {
      throw Exception('Você é o organizador deste evento.');
    }

    if (!evento.inscricoesAbertas) {
      throw Exception('As inscrições deste evento estão encerradas.');
    }

    final inscricaoId = _gerarInscricaoId(eventoId, usuarioId);
    final inscricaoDoc = await _inscricoesRef.doc(inscricaoId).get();

    if (inscricaoDoc.exists) {
      throw Exception('Você já está inscrito neste evento.');
    }

    await _inscricoesRef.doc(inscricaoId).set({
      'eventoId': evento.id,
      'usuarioId': usuario.uid,
      'emailUsuario': usuario.email ?? '',
      'tituloEvento': evento.titulo,
      'dataEvento': evento.data,
      'horarioEvento': evento.horario,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  /// Cancela a inscrição de um cliente em um evento.
  ///
  /// O usuário só pode cancelar a própria inscrição.
  Future<void> cancelarInscricao({
    required String eventoId,
    required String usuarioId,
  }) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    if (usuario.uid != usuarioId) {
      throw Exception('Você só pode cancelar sua própria inscrição.');
    }

    final inscricaoId = _gerarInscricaoId(eventoId, usuarioId);
    final inscricaoDoc = await _inscricoesRef.doc(inscricaoId).get();

    if (!inscricaoDoc.exists) {
      throw Exception('Inscrição não encontrada.');
    }

    await _inscricoesRef.doc(inscricaoId).delete();
  }

  /// Mantido por compatibilidade com telas antigas do projeto.
  ///
  /// Internamente usa o mesmo fluxo de `inscreverUsuario`.
  Future<void> inscreverUsuarioNoEvento(Evento evento) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Faça login para se inscrever.');
    }

    await inscreverUsuario(eventoId: evento.id, usuarioId: usuario.uid);
  }


  /// Verifica se um usuário já marcou determinado evento como favorito.
  ///
  /// Retorna true quando existe um documento na coleção `favoritos`
  /// com o mesmo eventoId e usuarioId.
  Future<bool> usuarioFavoritouEvento({
    required String eventoId,
    required String usuarioId,
  }) async {
    final favoritoId = _gerarFavoritoId(eventoId, usuarioId);
    final doc = await _favoritosRef.doc(favoritoId).get();

    return doc.exists;
  }

  /// Verifica se o usuário atualmente logado favoritou determinado evento.
  Future<bool> usuarioAtualFavoritouEvento(String eventoId) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return false;
    }

    return usuarioFavoritouEvento(
      eventoId: eventoId,
      usuarioId: usuario.uid,
    );
  }

  /// Adiciona um evento à lista de favoritos do usuário logado.
  ///
  /// Regra de negócio:
  /// - o usuário precisa estar autenticado;
  /// - o usuário só pode favoritar para a própria conta;
  /// - o evento precisa existir;
  /// - o mesmo favorito não pode ser duplicado.
  Future<void> favoritarEvento({
    required String eventoId,
    required String usuarioId,
  }) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Faça login para favoritar eventos.');
    }

    if (usuario.uid != usuarioId) {
      throw Exception('Você só pode favoritar eventos na sua própria conta.');
    }

    final evento = await buscarEventoPorId(eventoId);

    if (evento == null) {
      throw Exception('Evento não encontrado.');
    }

    final favoritoId = _gerarFavoritoId(eventoId, usuarioId);
    final favoritoDoc = await _favoritosRef.doc(favoritoId).get();

    if (favoritoDoc.exists) {
      throw Exception('Este evento já está nos seus favoritos.');
    }

    await _favoritosRef.doc(favoritoId).set({
      'eventoId': evento.id,
      'usuarioId': usuario.uid,
      'emailUsuario': usuario.email ?? '',
      'tituloEvento': evento.titulo,
      'dataEvento': evento.data,
      'horarioEvento': evento.horario,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  /// Remove um evento da lista de favoritos do usuário logado.
  Future<void> removerFavorito({
    required String eventoId,
    required String usuarioId,
  }) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    if (usuario.uid != usuarioId) {
      throw Exception('Você só pode remover favoritos da sua própria conta.');
    }

    final favoritoId = _gerarFavoritoId(eventoId, usuarioId);
    final favoritoDoc = await _favoritosRef.doc(favoritoId).get();

    if (!favoritoDoc.exists) {
      throw Exception('Favorito não encontrado.');
    }

    await _favoritosRef.doc(favoritoId).delete();
  }

  /// Lista, em tempo real, os eventos favoritados pelo usuário atual.
  ///
  /// A tela de Favoritos usa este método para exibir apenas os eventos
  /// que o usuário marcou com o ícone de coração.
  Stream<List<Evento>> listarEventosFavoritosUsuarioAtual() {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return Stream.value(<Evento>[]);
    }

    return _favoritosRef
        .where('usuarioId', isEqualTo: usuario.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      final eventoIds = snapshot.docs
          .map((doc) => doc.data()['eventoId'])
          .whereType<String>()
          .toSet()
          .toList();

      if (eventoIds.isEmpty) {
        return <Evento>[];
      }

      final eventos = <Evento>[];

      for (final eventoId in eventoIds) {
        final evento = await buscarEventoPorId(eventoId);

        if (evento != null) {
          eventos.add(evento);
        }
      }

      return eventos;
    });
  }

  /// Monta um ID determinístico para impedir duplicidade de inscrição.
  String _gerarInscricaoId(String eventoId, String usuarioId) {
    return '${eventoId}_$usuarioId';
  }

  /// Monta um ID determinístico para impedir duplicidade de favorito.
  String _gerarFavoritoId(String eventoId, String usuarioId) {
    return '${eventoId}_$usuarioId';
  }
}
