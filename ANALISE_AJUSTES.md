# Análise técnica dos ajustes realizados

## Problemas encontrados no ZIP enviado

1. **Login não autenticava no Firebase**
   - A tela de login apenas redirecionava para `/home`.
   - Não havia validação real de email/senha.
   - Não havia tratamento de erros do Firebase Auth.

2. **Cadastro de usuário não criava conta real**
   - A tela de cadastro apenas voltava para o login.
   - Campos como nome, email e senha não eram controlados por `TextEditingController`.
   - Não havia validação de senha e confirmação.

3. **Eventos eram dados fixos**
   - O app usava `mock_events.dart`, ou seja, os eventos estavam apenas no código.
   - Isso é incoerente com a etapa atual do projeto, pois você já iniciou a configuração do Firebase/Firestore.

4. **Cadastro de evento não salvava nada**
   - O botão “Salvar” apenas navegava para `/home`.
   - As informações digitadas eram perdidas.

5. **Detalhes do evento dependiam de mock**
   - A tela buscava o evento em `mockEvents`.
   - Se o ID não existisse, ela abria o primeiro evento, o que é incoerente e poderia mostrar informação errada.

6. **Filtros não retornavam dados para a Home**
   - A tela de filtros apenas dava `Navigator.pop(context)`.
   - A Home não recebia os filtros selecionados.

7. **Repetição visual aceitável, mas sem comentários**
   - Vários widgets estavam corretos visualmente, porém sem explicação.
   - Foram adicionados comentários em pontos-chave para facilitar estudo e apresentação.

## O que foi alterado

1. `main.dart`
   - Agora inicializa o Firebase antes de abrir o app.
   - A rota inicial aponta para `AuthGate`, que decide se o usuário vai para login ou home.

2. `auth_gate.dart`
   - Novo arquivo responsável por verificar se existe usuário logado.
   - Usa `FirebaseAuth.instance.authStateChanges()`.

3. `login_screen.dart`
   - Passou a usar `FirebaseAuth.signInWithEmailAndPassword()`.
   - Adicionadas validações básicas e mensagens em português.

4. `cadastro_screen.dart`
   - Passou a criar conta real com `FirebaseAuth.createUserWithEmailAndPassword()`.
   - Atualiza o `displayName` do usuário.

5. `models/evento.dart`
   - Modelo expandido para representar um documento do Firestore.
   - Inclui conversão `fromFirestore()` e `toMap()`.

6. `services/evento_service.dart`
   - Centraliza as operações do Firestore.
   - Lista, cria e busca eventos por ID.

7. `home_screen.dart`
   - Removeu `mock_events.dart`.
   - Agora usa `StreamBuilder` para ouvir eventos do Firestore em tempo real.

8. `cadastro_evento_screen.dart`
   - Agora salva eventos na coleção `eventos`.
   - Valida campos obrigatórios.
   - Associa o evento ao UID do usuário logado.

9. `evento_detalhe_screen.dart`
   - Agora busca o evento real pelo ID do Firestore.
   - Removeu o comportamento incoerente de abrir o primeiro evento quando o ID não existia.

10. `filtros_screen.dart`
   - Agora retorna um objeto `FiltrosEventos` para a Home.
   - A Home aplica os filtros localmente sobre os eventos recebidos do Firestore.

## Arquivos removidos conceitualmente

- `lib/data/mock_events.dart`

Esse arquivo não foi mantido porque era redundante após a integração com Firestore.
