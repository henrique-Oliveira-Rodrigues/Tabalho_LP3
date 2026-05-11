class Evento {
  final String id;
  final String titulo;
  final String data;
  final String local;
  final String imagemUrl;
  final bool gratuito;
  final bool inscricoesAbertas;

  const Evento({
    required this.id,
    required this.titulo,
    required this.data,
    required this.local,
    required this.imagemUrl,
    required this.gratuito,
    required this.inscricoesAbertas,
  });
}
