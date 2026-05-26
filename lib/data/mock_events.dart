import '../models/evento.dart';

const List<Evento> mockEvents = [
  Evento(
    id: '1',
    titulo: 'Feira de Artesanato Local',
    data: '15 Mai • 10:00',
    local: 'Praça Central, Centro',
    imagemUrl: 'https://images.unsplash.com/photo-1474625121024-7595bfbc57ac?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080',
    gratuito: true,
    inscricoesAbertas: true,
  ),
  Evento(
    id: '2',
    titulo: 'Workshop de Fotografia Mobile',
    data: '20 Mai • 14:00',
    local: 'Biblioteca Municipal',
    imagemUrl: 'https://images.unsplash.com/photo-1752649938189-25651a4040fe?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080',
    gratuito: false,
    inscricoesAbertas: true,
  ),
  Evento(
    id: '3',
    titulo: 'Festival de Comida de Rua',
    data: '22 Mai • 18:00',
    local: 'Parque da Cidade',
    imagemUrl: 'https://images.unsplash.com/photo-1683731509782-22668b4ba48d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080',
    gratuito: true,
    inscricoesAbertas: false,
  ),
];
