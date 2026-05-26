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
