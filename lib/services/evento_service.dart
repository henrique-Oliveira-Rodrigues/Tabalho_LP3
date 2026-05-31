import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../models/evento.dart';

/// Serviço responsável por centralizar toda comunicação com o Firestore.
///
/// Essa camada evita espalhar comandos como `FirebaseFirestore.instance` pelas
/// telas. Assim, as telas ficam focadas na interface e este serviço fica focado
/// nas operações de dados e regras de segurança do lado do app.
class EventoService {
  /// Coleção principal onde os eventos são armazenados.
  final CollectionReference<Map<String, dynamic>> _eventosRef =
      FirebaseFirestore.instance.collection('eventos');

  /// Coleção usada para registrar inscrições de clientes em eventos.
  ///
  /// Cada documento possui ID composto: `eventoId_uidDoUsuario`.
  /// Isso impede duas inscrições iguais para o mesmo usuário/evento.
  final CollectionReference<Map<String, dynamic>> _inscricoesRef =
      FirebaseFirestore.instance.collection('inscricoes');

  /// Coleção de usuários. Ela guarda o campo `ehEmpresa`, usado na regra
  /// de negócio para diferenciar empresa/organizador de cliente comum.
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
  /// - `ehEmpresa == true`: pode cadastrar eventos.
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
  /// A tela já faz as validações de formulário, mas o service também valida
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

  /// Verifica se um usuário já está inscrito em determinado evento.
///
/// Retorna true se existir uma inscrição com o mesmo eventoId e usuarioId.
Future<bool> usuarioEstaInscrito({
  required String eventoId,
  required String usuarioId,
}) async {
  final consulta = await FirebaseFirestore.instance
      .collection('inscricoes')
      .where('eventoId', isEqualTo: eventoId)
      .where('usuarioId', isEqualTo: usuarioId)
      .limit(1)
      .get();

  return consulta.docs.isNotEmpty;
}

/// Realiza a inscrição do cliente em um evento.
///
/// Antes de criar a inscrição, verifica se ele já está inscrito
/// para evitar duplicidade.
Future<void> inscreverUsuario({
  required String eventoId,
  required String usuarioId,
}) async {
  final jaInscrito = await usuarioEstaInscrito(
    eventoId: eventoId,
    usuarioId: usuarioId,
  );

  if (jaInscrito) {
    throw Exception('Você já está inscrito neste evento.');
  }

  await FirebaseFirestore.instance.collection('inscricoes').add({
    'eventoId': eventoId,
    'usuarioId': usuarioId,
    'criadoEm': FieldValue.serverTimestamp(),
  });
}

/// Cancela a inscrição do cliente em um evento.
///
/// Procura a inscrição pelo eventoId e usuarioId.
/// Se encontrar, exclui o documento da coleção inscricoes.
Future<void> cancelarInscricao({
  required String eventoId,
  required String usuarioId,
}) async {
  final consulta = await FirebaseFirestore.instance
      .collection('inscricoes')
      .where('eventoId', isEqualTo: eventoId)
      .where('usuarioId', isEqualTo: usuarioId)
      .limit(1)
      .get();

  if (consulta.docs.isEmpty) {
    throw Exception('Inscrição não encontrada.');
  }

  await consulta.docs.first.reference.delete();
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

    // Remove inscrições relacionadas ao evento excluído para não deixar
    // documentos órfãos na coleção `inscricoes`.
    final inscricoes = await _inscricoesRef.where('eventoId', isEqualTo: id).get();
    final batch = FirebaseFirestore.instance.batch();

    for (final inscricao in inscricoes.docs) {
      batch.delete(inscricao.reference);
    }

    await batch.commit();
  }



  /// Verifica se o usuário atual já está inscrito em determinado evento.
  Future<bool> usuarioAtualEstaInscrito(String eventoId) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return false;
    }

    final inscricaoId = _gerarInscricaoId(eventoId, usuario.uid);
    final doc = await _inscricoesRef.doc(inscricaoId).get();

    return doc.exists;
  }

  /// Inscreve o usuário atual em um evento.
  ///
  /// Regra de negócio:
  /// - empresa/organizador não se inscreve como cliente;
  /// - cliente só se inscreve se as inscrições estiverem abertas;
  /// - um cliente não pode se inscrever duas vezes no mesmo evento.
  Future<void> inscreverUsuarioNoEvento(Evento evento) async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Faça login para se inscrever.');
    }

    final ehEmpresa = await usuarioAtualEhEmpresa();

    if (ehEmpresa) {
      throw Exception('Conta empresarial gerencia eventos e não realiza inscrição.');
    }

    if (!evento.inscricoesAbertas) {
      throw Exception('As inscrições deste evento estão encerradas.');
    }

    final inscricaoId = _gerarInscricaoId(evento.id, usuario.uid);
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

  /// Monta um ID determinístico para impedir duplicidade de inscrição.
  String _gerarInscricaoId(String eventoId, String usuarioId) {
    return '${eventoId}_$usuarioId';
  }
}

  /// Verifica se um usuário já está inscrito em determinado evento.
  ///
  /// Retorna true se existir uma inscrição com o mesmo eventoId e usuarioId.
  Future<bool> usuarioEstaInscrito({
    required String eventoId,
    required String usuarioId,
  }) async {
    final consulta = await FirebaseFirestore.instance
        .collection('inscricoes')
        .where('eventoId', isEqualTo: eventoId)
        .where('usuarioId', isEqualTo: usuarioId)
        .limit(1)
        .get();

    return consulta.docs.isNotEmpty;
  }

  /// Realiza a inscrição do cliente em um evento.
  ///
  /// Antes de criar a inscrição, verifica se ele já está inscrito
  /// para evitar duplicidade.
  Future<void> inscreverUsuario({
    required String eventoId,
    required String usuarioId,
  }) async {
    final jaInscrito = await usuarioEstaInscrito(
      eventoId: eventoId,
      usuarioId: usuarioId,
    );

    if (jaInscrito) {
      throw Exception('Você já está inscrito neste evento.');
    }

    await FirebaseFirestore.instance.collection('inscricoes').add({
      'eventoId': eventoId,
      'usuarioId': usuarioId,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  /// Cancela a inscrição do cliente em um evento.
  ///
  /// Procura a inscrição pelo eventoId e usuarioId.
  /// Se encontrar, exclui o documento da coleção inscricoes.
  Future<void> cancelarInscricao({
    required String eventoId,
    required String usuarioId,
  }) async {
    final consulta = await FirebaseFirestore.instance
        .collection('inscricoes')
        .where('eventoId', isEqualTo: eventoId)
        .where('usuarioId', isEqualTo: usuarioId)
        .limit(1)
        .get();

    if (consulta.docs.isEmpty) {
      throw Exception('Inscrição não encontrada.');
    }

    await consulta.docs.first.reference.delete();
  }
