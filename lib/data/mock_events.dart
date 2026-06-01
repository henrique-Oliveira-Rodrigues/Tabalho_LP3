import '../models/evento.dart';

/// Lista de eventos simulados.
///
/// Este arquivo era usado antes da integração com Firestore.
/// Atualmente, os eventos reais vêm da coleção `eventos` no Firebase.
/// Mesmo assim, mantemos o mock válido para testes locais ou referência visual.
final List<Evento> mockEvents = [
  Evento(
    id: '1',
    titulo: 'Feira Cultural no Centro',
    descricao: 'Evento cultural gratuito com apresentações, música e barracas locais.',
    data: '20/05/2026',
    horario: '19:00',
    local: 'Praça Central',
    bairro: 'Centro',
    linkInscricao: '',
    imagemUrl:
        'https://images.unsplash.com/photo-1572649938189-25651a4040fe?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080',
    gratuito: false,
    inscricoesAbertas: true,
    criadoPor: 'mock_empresa_1',
    dataHora: DateTime(2026, 5, 20, 19, 0),
  ),
  Evento(
    id: '2',
    titulo: 'Festival de Comida de Rua',
    descricao: 'Festival gastronômico com food trucks, música ao vivo e espaços para famílias.',
    data: '22/05/2026',
    horario: '18:00',
    local: 'Parque da Cidade',
    bairro: 'Jardim Primavera',
    linkInscricao: '',
    imagemUrl:
        'https://images.unsplash.com/photo-1683731509782-22668b4ba48d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080',
    gratuito: true,
    inscricoesAbertas: false,
    criadoPor: 'mock_empresa_2',
    dataHora: DateTime(2026, 5, 22, 18, 0),
  ),
];