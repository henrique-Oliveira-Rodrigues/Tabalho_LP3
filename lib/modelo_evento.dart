import 'package:cloud_firestore/cloud_firestore.dart';

class Evento {
  final String id;
  final String titulo;
  final String descricao;
  final String data;
  final String horario;
  final String local;
  final String bairro;
  final String linkInscricao;
  final String imagemUrl;
  final bool gratuito;
  final bool inscricoesAbertas;
  final String? uid;

  const Evento({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.horario,
    required this.local,
    required this.bairro,
    required this.linkInscricao,
    required this.imagemUrl,
    required this.gratuito,
    required this.inscricoesAbertas,
    this.uid,
  });

  factory Evento.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return Evento(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'] ?? '',
      data: data['data'] ?? '',
      horario: data['horario'] ?? '',
      local: data['local'] ?? '',
      bairro: data['bairro'] ?? '',
      linkInscricao: data['linkInscricao'] ?? '',
      imagemUrl: data['imagemUrl'] ?? '',
      gratuito: data['gratuito'] ?? false,
      inscricoesAbertas: data['inscricoesAbertas'] ?? false,
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
      'horario': horario,
      'local': local,
      'bairro': bairro,
      'linkInscricao': linkInscricao,
      'imagemUrl': imagemUrl,
      'gratuito': gratuito,
      'inscricoesAbertas': inscricoesAbertas,
      'uid': uid,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
