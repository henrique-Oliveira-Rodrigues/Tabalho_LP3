import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo que representa um evento da Agenda Local.
///
/// A função desta classe é evitar que as telas manipulem diretamente
/// mapas (`Map<String, dynamic>`) do Firestore. Com isso, o código fica
/// mais organizado, tipado e fácil de manter.
class Evento {
  /// ID do documento no Firestore. Ele não é digitado pelo usuário.
  final String id;

  /// Dados principais exibidos no card e na tela de detalhes.
  final String titulo;
  final String descricao;
  final String data;
  final String horario;
  final String local;
  final String bairro;

  /// Campos opcionais usados na inscrição e na imagem do card.
  final String linkInscricao;
  final String imagemUrl;

  /// Regras simples de exibição/filtro.
  final bool gratuito;
  final bool inscricoesAbertas;

  /// UID do usuário/empresa que criou o evento.
  /// Esse campo é usado para permitir edição/exclusão somente pelo criador.
  final String criadoPor;

  /// Data e hora combinadas do evento.
  /// Esse campo facilita validações e futuras ordenações por data real.
  final DateTime? dataHora;

  /// Data de criação do registro no Firestore.
  final DateTime? criadoEm;

  /// Data da última atualização do registro no Firestore.
  final DateTime? atualizadoEm;

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
    this.dataHora,
    this.criadoEm,
    this.atualizadoEm,
  });

  /// Cria um objeto Evento a partir de um documento do Firestore.
  ///
  /// O Firestore pode retornar documentos antigos sem alguns campos.
  /// Por isso usamos valores padrão (`?? ''`, `?? false`) para evitar
  /// erros de tela quando algum campo não existir.
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
      dataHora: _timestampParaDateTime(dados['dataHora']),
      criadoEm: _timestampParaDateTime(dados['criadoEm']),
      atualizadoEm: _timestampParaDateTime(dados['atualizadoEm']),
    );
  }

  /// Converte Timestamp do Firestore para DateTime do Dart.
  static DateTime? _timestampParaDateTime(dynamic valor) {
    if (valor is Timestamp) {
      return valor.toDate();
    }
    return null;
  }

  /// Mapa usado no cadastro de um novo evento.
  ///
  /// O `id` não entra aqui porque o Firestore cria o ID automaticamente.
  /// `criadoEm` e `atualizadoEm` usam o horário do servidor do Firebase.
  Map<String, dynamic> toCreateMap() {
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
      'dataHora': dataHora != null ? Timestamp.fromDate(dataHora!) : null,
      'criadoEm': FieldValue.serverTimestamp(),
      'atualizadoEm': FieldValue.serverTimestamp(),
    };
  }

  /// Mapa usado na atualização de um evento existente.
  ///
  /// Aqui não alteramos `criadoPor` nem `criadoEm`, pois esses dados
  /// pertencem ao histórico original do evento.
  Map<String, dynamic> toUpdateMap() {
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
      'dataHora': dataHora != null ? Timestamp.fromDate(dataHora!) : null,
      'atualizadoEm': FieldValue.serverTimestamp(),
    };
  }
}
