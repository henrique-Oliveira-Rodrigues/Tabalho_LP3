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
  final String criadoPor;
  final DateTime? criadoEm;

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
    required this.criadoPor,
    this.criadoEm,
  });

  // Converte um documento do Firestore em um objeto Evento.
  // Isso evita espalhar leitura de Map<String, dynamic> pelas telas.
  factory Evento.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final dados = doc.data() ?? <String, dynamic>{};

    return Evento(
      id: doc.id,
      titulo: dados['titulo'] ?? '',
      descricao: dados['descricao'] ?? '',
      data: dados['data'] ?? '',
      horario: dados['horario'] ?? '',
      local: dados['local'] ?? '',
      bairro: dados['bairro'] ?? '',
      linkInscricao: dados['linkInscricao'] ?? '',
      imagemUrl: dados['imagemUrl'] ?? '',
      gratuito: dados['gratuito'] ?? false,
      inscricoesAbertas: dados['inscricoesAbertas'] ?? false,
      criadoPor: dados['criadoPor'] ?? '',
      criadoEm: dados['criadoEm'] is Timestamp
          ? (dados['criadoEm'] as Timestamp).toDate()
          : null,
    );
  }

  // Converte um objeto Evento em Map para salvar no Firestore.
  // O id não entra aqui porque o Firestore gera o id do documento automaticamente.
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
      'criadoPor': criadoPor,
      'criadoEm': FieldValue.serverTimestamp(),
    };
  }
}
