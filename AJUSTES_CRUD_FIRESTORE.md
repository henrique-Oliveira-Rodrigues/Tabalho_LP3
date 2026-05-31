# Ajustes aplicados: validações, CRUD e regras de negócio

## Validações adicionadas

- Validação de data no formato `dd/mm/aaaa`.
- Validação de horário no formato `HH:mm`.
- Bloqueio de evento com data/hora no passado.
- Validação de título com no mínimo 3 caracteres.
- Validação de descrição com no mínimo 10 caracteres.
- Validação de URL de inscrição e imagem iniciando com `http` ou `https`.
- Uso de `showDatePicker` e `showTimePicker` para reduzir erro de digitação.

## CRUD de eventos

- Create: empresas podem cadastrar eventos.
- Read: usuários autenticados podem visualizar eventos.
- Update: apenas o criador do evento pode editar.
- Delete: apenas o criador do evento pode excluir.
- Ao excluir um evento, as inscrições relacionadas também são removidas.

## Regra de negócio empresa x cliente

- Usuário com `usuarios/{uid}.ehEmpresa == true`:
  - pode cadastrar eventos;
  - pode editar/excluir apenas eventos criados por ele;
  - não pode se inscrever como cliente.

- Usuário com `usuarios/{uid}.ehEmpresa == false`:
  - não pode cadastrar eventos;
  - não pode editar/excluir eventos;
  - pode se inscrever em eventos com inscrições abertas.

## Arquivos principais alterados

- `lib/models/evento.dart`
- `lib/services/evento_service.dart`
- `lib/screens/cadastro_evento_screen.dart`
- `lib/screens/evento_detalhe_screen.dart`
- `lib/main.dart`
- `firestore.rules`
- `firebase.json`

## Regras do Firestore

Foi criado o arquivo `firestore.rules`. Para publicar essas regras no Firebase, use:

```bash
firebase deploy --only firestore:rules
```

Se ainda não estiver logado no Firebase CLI:

```bash
firebase login
```

## Comandos recomendados após substituir o projeto

```bash
flutter clean
flutter pub get
flutter run -d chrome
```

Depois de testar:

```bash
git add .
git commit -m "Implementa validações e CRUD de eventos"
git push origin main
```
