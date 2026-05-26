<<<<<<< HEAD
# Agenda Local - Flutter ajustado

Esta versão removeu a dependência de dados simulados (`mock_events.dart`) e passou a usar:

- Firebase Authentication para login e cadastro de usuários.
- Cloud Firestore para cadastro, listagem e detalhes dos eventos.
- Código comentado em português para facilitar estudo e manutenção.

## Atenção sobre `firebase_options.dart`

O arquivo `lib/firebase_options.dart` é gerado pelo comando abaixo e contém dados específicos do seu projeto Firebase:

```bash
flutterfire configure --project=projeto-agenda-e0465
```

Se você já tem esse arquivo funcionando no seu projeto, **não substitua por outro**. Apenas mantenha o seu `firebase_options.dart` dentro de `lib/`.

## Como rodar

```bash
flutter pub get
flutter run -d chrome
```

## Coleção usada no Firestore

Coleção: `eventos`

Campos principais:

- `titulo`
- `descricao`
- `data`
- `horario`
- `local`
- `bairro`
- `linkInscricao`
- `imagemUrl`
- `gratuito`
- `inscricoesAbertas`
- `criadoPor`
- `criadoEm`
=======
# Agenda Local - Flutter

Projeto reescrito em Flutter/Dart a partir do protótipo React/TSX.

## Como executar

```bash
flutter pub get
flutter run
```

## Estrutura

- `lib/main.dart`: tema, rotas e inicialização.
- `lib/models/evento.dart`: modelo de evento.
- `lib/data/mock_events.dart`: lista de eventos simulados.
- `lib/screens/`: telas do aplicativo.
- `lib/widgets/`: componentes reutilizáveis.

## Observações da conversão

Os componentes React/shadcn não foram convertidos arquivo por arquivo. Eles foram substituídos por widgets nativos do Flutter, como `Scaffold`, `Card`, `TextField`, `ElevatedButton`, `BottomNavigationBar`, `Switch` e componentes customizados quando necessário.
"# Tabalho_LP3" 
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
