import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/evento.dart';

class EventoService {
  // Referência centralizada para a coleção de eventos.
  // Assim, se o nome da coleção mudar, alteramos em apenas um lugar.
  final CollectionReference<Map<String, dynamic>> _eventosRef =
      FirebaseFirestore.instance.collection('eventos');

  // Retorna os eventos em tempo real.
  // Quando um documento muda no Firestore, a tela que usa esse Stream atualiza sozinha.
  Stream<List<Evento>> listarEventos() {
    return _eventosRef
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(Evento.fromFirestore).toList();
    });
  }

  // Salva um novo evento no Firestore.
  // O método add cria um documento com ID automático.
  Future<void> criarEvento(Evento evento) async {
    await _eventosRef.add(evento.toMap());
  }

  // Busca um evento específico pelo ID do documento.
  Future<Evento?> buscarEventoPorId(String id) async {
    final doc = await _eventosRef.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return Evento.fromFirestore(doc);
  }

  // Remove um evento do Firestore.
  // Pode ser usado futuramente em uma tela de administração ou perfil.
  Future<void> excluirEvento(String id) async {
    await _eventosRef.doc(id).delete();
  }
}
