import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/evento.dart';
import '../services/evento_service.dart';
import '../widgets/ios_toggle.dart';

/// Tela usada para cadastrar e editar eventos.
///
/// Se `eventoId` for nulo, a tela funciona em modo cadastro.
/// Se `eventoId` vier preenchido, a tela funciona em modo edição.
class CadastroEventoScreen extends StatefulWidget {
  final String? eventoId;

  const CadastroEventoScreen({
    super.key,
    this.eventoId,
  });

  @override
  State<CadastroEventoScreen> createState() => _CadastroEventoScreenState();
}

class _CadastroEventoScreenState extends State<CadastroEventoScreen> {
  /// Chave do formulário. Permite executar todos os validators antes de salvar.
  final _formKey = GlobalKey<FormState>();

  /// Serviço responsável pelas operações no Firestore.
  final EventoService eventoService = EventoService();

  /// Controllers dos campos do formulário.
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  final dataController = TextEditingController();
  final horarioController = TextEditingController();
  final localController = TextEditingController();
  final bairroController = TextEditingController();
  final linkInscricaoController = TextEditingController();
  final imagemUrlController = TextEditingController();

  /// Controles booleanos do evento.
  bool gratuito = false;
  bool inscricoesAbertas = true;

  /// Estados de carregamento.
  bool carregando = false;
  bool carregandoEvento = false;

  /// Evento original usado quando a tela está em modo edição.
  Evento? eventoOriginal;

  /// Define se a tela está cadastrando ou editando.
  bool get modoEdicao => widget.eventoId != null;

  @override
  void initState() {
    super.initState();

    if (modoEdicao) {
      carregarEventoParaEdicao();
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    dataController.dispose();
    horarioController.dispose();
    localController.dispose();
    bairroController.dispose();
    linkInscricaoController.dispose();
    imagemUrlController.dispose();
    super.dispose();
  }

  /// Mostra mensagens rápidas para o usuário.
  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  /// Carrega os dados de um evento existente para edição.
  Future<void> carregarEventoParaEdicao() async {
    setState(() => carregandoEvento = true);

    try {
      final evento = await eventoService.buscarEventoPorId(widget.eventoId!);
      final usuario = FirebaseAuth.instance.currentUser;

      if (!mounted) return;

      if (evento == null) {
        mostrarMensagem('Evento não encontrado.');
        Navigator.pop(context);
        return;
      }

      /// Regra de negócio:
      /// somente o usuário que criou o evento pode editá-lo.
      if (usuario == null || evento.criadoPor != usuario.uid) {
        mostrarMensagem('Você só pode editar eventos criados por você.');
        Navigator.pop(context);
        return;
      }

      eventoOriginal = evento;

      tituloController.text = evento.titulo;
      descricaoController.text = evento.descricao;
      dataController.text = evento.data;
      horarioController.text = evento.horario;
      localController.text = evento.local;
      bairroController.text = evento.bairro;
      linkInscricaoController.text = evento.linkInscricao;
      imagemUrlController.text = evento.imagemUrl;

      gratuito = evento.gratuito;
      inscricoesAbertas = evento.inscricoesAbertas;
    } catch (_) {
      if (!mounted) return;

      mostrarMensagem('Erro ao carregar evento para edição.');
      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() => carregandoEvento = false);
      }
    }
  }

  /// Converte uma data no formato dd/mm/aaaa para DateTime.
  ///
  /// Retorna `null` caso a data seja inválida.
  DateTime? converterData(String data) {
    final partes = data.split('/');

    if (partes.length != 3) {
      return null;
    }

    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final ano = int.tryParse(partes[2]);

    if (dia == null || mes == null || ano == null) {
      return null;
    }

    final dataConvertida = DateTime(ano, mes, dia);

    /// O Dart ajusta automaticamente datas inválidas.
    /// Exemplo: DateTime(2026, 13, 40) vira outra data.
    /// Por isso fazemos a conferência abaixo.
    if (dataConvertida.day != dia ||
        dataConvertida.month != mes ||
        dataConvertida.year != ano) {
      return null;
    }

    return dataConvertida;
  }

  /// Converte um horário no formato HH:mm para TimeOfDay.
  ///
  /// Retorna `null` caso o horário seja inválido.
  TimeOfDay? converterHorario(String horario) {
    final partes = horario.split(':');

    if (partes.length != 2) {
      return null;
    }

    final hora = int.tryParse(partes[0]);
    final minuto = int.tryParse(partes[1]);

    if (hora == null || minuto == null) {
      return null;
    }

    if (hora < 0 || hora > 23 || minuto < 0 || minuto > 59) {
      return null;
    }

    return TimeOfDay(hour: hora, minute: minuto);
  }

  /// Junta a data e o horário em um único DateTime.
  ///
  /// Isso é usado para validar se o evento está no passado e também para salvar
  /// uma data ordenável no Firestore.
  DateTime? montarDataHoraEvento(String data, String horario) {
    final dataConvertida = converterData(data);
    final horarioConvertido = converterHorario(horario);

    if (dataConvertida == null || horarioConvertido == null) {
      return null;
    }

    return DateTime(
      dataConvertida.year,
      dataConvertida.month,
      dataConvertida.day,
      horarioConvertido.hour,
      horarioConvertido.minute,
    );
  }

  /// Abre o seletor visual de data.
  Future<void> selecionarData() async {
    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month, agora.day);
    final dataAtualCampo = converterData(dataController.text);

    /// O initialDate não pode ser menor que o firstDate.
    /// Se o campo estiver vazio ou com data antiga, usamos hoje.
    final dataInicial = dataAtualCampo != null && !dataAtualCampo.isBefore(hoje)
        ? dataAtualCampo
        : hoje;

    final escolhida = await showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: hoje,
      lastDate: DateTime(agora.year + 5),
    );

    if (escolhida == null) return;

    final dia = escolhida.day.toString().padLeft(2, '0');
    final mes = escolhida.month.toString().padLeft(2, '0');
    final ano = escolhida.year.toString();

    setState(() {
      dataController.text = '$dia/$mes/$ano';
    });
  }

  /// Abre o seletor visual de horário.
  Future<void> selecionarHorario() async {
    final horarioAtualCampo = converterHorario(horarioController.text);

    final escolhido = await showTimePicker(
      context: context,
      initialTime: horarioAtualCampo ?? TimeOfDay.now(),
    );

    if (escolhido == null) return;

    final hora = escolhido.hour.toString().padLeft(2, '0');
    final minuto = escolhido.minute.toString().padLeft(2, '0');

    setState(() {
      horarioController.text = '$hora:$minuto';
    });
  }

  /// Validação complementar que depende da combinação data + horário.
  String? validarRegrasDoEvento(DateTime? dataHora) {
    if (dataHora == null) {
      return 'Informe uma data e horário válidos.';
    }

    if (dataHora.isBefore(DateTime.now())) {
      return 'A data e o horário do evento não podem estar no passado.';
    }

    return null;
  }

  /// Salva o evento no Firestore.
  ///
  /// Fluxos atendidos:
  /// - cadastro: cria um novo documento em `eventos`;
  /// - edição: atualiza o documento existente.
  Future<void> salvarEvento() async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      mostrarMensagem('Você precisa estar logado para salvar evento.');
      return;
    }

    /// Executa as validações dos TextFormField.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final data = dataController.text.trim();
    final horario = horarioController.text.trim();
    final dataHora = montarDataHoraEvento(data, horario);

    final erroRegraEvento = validarRegrasDoEvento(dataHora);

    if (erroRegraEvento != null) {
      mostrarMensagem(erroRegraEvento);
      return;
    }

    setState(() => carregando = true);

    try {
      final evento = Evento(
        id: widget.eventoId ?? '',
        titulo: tituloController.text.trim(),
        descricao: descricaoController.text.trim(),
        data: data,
        horario: horario,
        local: localController.text.trim(),
        bairro: bairroController.text.trim(),
        linkInscricao: linkInscricaoController.text.trim(),
        imagemUrl: imagemUrlController.text.trim(),
        gratuito: gratuito,
        inscricoesAbertas: inscricoesAbertas,
        criadoPor: eventoOriginal?.criadoPor ?? usuario.uid,
        dataHora: dataHora,
      );

      if (modoEdicao) {
        await eventoService.atualizarEvento(evento);
        mostrarMensagem('Evento atualizado com sucesso!');
      } else {
        await eventoService.criarEvento(evento);
        mostrarMensagem('Evento cadastrado com sucesso!');
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      mostrarMensagem(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tituloTela = modoEdicao ? 'Editar Evento' : 'Novo Evento';
    final textoBotao = modoEdicao ? 'Salvar alterações' : 'Cadastrar evento';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tituloTela,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: carregando ? null : () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: carregandoEvento
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          _Field(
                            controller: tituloController,
                            label: 'Título do Evento *',
                            hint: 'Ex: Workshop de Fotografia',
                            validator: (value) {
                              final texto = value?.trim() ?? '';

                              if (texto.isEmpty) {
                                return 'Informe o título do evento.';
                              }

                              if (texto.length < 3) {
                                return 'O título deve ter pelo menos 3 caracteres.';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          _Field(
                            controller: descricaoController,
                            label: 'Descrição *',
                            hint: 'Conte mais sobre o evento...',
                            maxLines: 4,
                            validator: (value) {
                              final texto = value?.trim() ?? '';

                              if (texto.isEmpty) {
                                return 'Informe a descrição do evento.';
                              }

                              if (texto.length < 10) {
                                return 'A descrição deve ter pelo menos 10 caracteres.';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: _Field(
                                  controller: dataController,
                                  label: 'Data *',
                                  hint: 'dd/mm/aaaa',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [DataInputFormatter()],
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_month),
                                    onPressed: selecionarData,
                                  ),
                                  validator: (value) {
                                    final texto = value?.trim() ?? '';

                                    if (texto.isEmpty) {
                                      return 'Informe a data.';
                                    }

                                    if (!RegExp(r'^\d{2}/\d{2}/\d{4}$')
                                        .hasMatch(texto)) {
                                      return 'Use dd/mm/aaaa.';
                                    }

                                    if (converterData(texto) == null) {
                                      return 'Data inválida.';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _Field(
                                  controller: horarioController,
                                  label: 'Horário *',
                                  hint: 'HH:mm',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [HoraInputFormatter()],
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.access_time),
                                    onPressed: selecionarHorario,
                                  ),
                                  validator: (value) {
                                    final texto = value?.trim() ?? '';

                                    if (texto.isEmpty) {
                                      return 'Informe o horário.';
                                    }

                                    if (!RegExp(r'^\d{2}:\d{2}$')
                                        .hasMatch(texto)) {
                                      return 'Use HH:mm.';
                                    }

                                    if (converterHorario(texto) == null) {
                                      return 'Horário inválido.';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _Field(
                            controller: localController,
                            label: 'Local *',
                            hint: 'Ex: Praça Central',
                            validator: (value) {
                              final texto = value?.trim() ?? '';

                              if (texto.isEmpty) {
                                return 'Informe o local do evento.';
                              }

                              if (texto.length < 3) {
                                return 'O local deve ter pelo menos 3 caracteres.';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          _Field(
                            controller: bairroController,
                            label: 'Bairro *',
                            hint: 'Ex: Centro',
                            validator: (value) {
                              final texto = value?.trim() ?? '';

                              if (texto.isEmpty) {
                                return 'Informe o bairro.';
                              }

                              if (texto.length < 2) {
                                return 'Informe um bairro válido.';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          _Field(
                            controller: linkInscricaoController,
                            label: 'Link de Inscrição',
                            hint: 'https://...',
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              final texto = value?.trim() ?? '';

                              if (texto.isEmpty) {
                                return null;
                              }

                              if (!texto.startsWith('http://') &&
                                  !texto.startsWith('https://')) {
                                return 'O link deve começar com http:// ou https://.';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          _Field(
                            controller: imagemUrlController,
                            label: 'Imagem do Evento',
                            hint: 'URL da imagem, opcional',
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              final texto = value?.trim() ?? '';

                              if (texto.isEmpty) {
                                return null;
                              }

                              if (!texto.startsWith('http://') &&
                                  !texto.startsWith('https://')) {
                                return 'A URL deve começar com http:// ou https://.';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 18),
                          _ToggleLine(
                            title: 'Gratuito',
                            subtitle: 'O evento não tem custo para o público',
                            value: gratuito,
                            onChanged: (value) {
                              setState(() => gratuito = value);
                            },
                          ),
                          const SizedBox(height: 22),
                          _ToggleLine(
                            title: 'Inscrições abertas',
                            subtitle:
                                'Clientes poderão se inscrever neste evento',
                            value: inscricoesAbertas,
                            onChanged: (value) {
                              setState(() => inscricoesAbertas = value);
                            },
                          ),
                          const SizedBox(height: 34),
                          ElevatedButton(
                            onPressed: carregando ? null : salvarEvento,
                            child: Text(
                              carregando ? 'Salvando...' : textoBotao,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Campo reutilizável do formulário.
///
/// Usa TextFormField para permitir validações integradas ao `Form`.
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType:
              keyboardType ?? (maxLines > 1 ? TextInputType.multiline : null),
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// Formatador para data no padrão dd/mm/aaaa.
///
/// O usuário digita apenas números.
/// Exemplo: 01062026 -> 01/06/2026.
class DataInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var texto = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (texto.length > 8) {
      texto = texto.substring(0, 8);
    }

    final buffer = StringBuffer();

    for (var i = 0; i < texto.length; i++) {
      if (i == 2) buffer.write('/');
      if (i == 4) buffer.write('/');

      buffer.write(texto[i]);
    }

    final textoFormatado = buffer.toString();

    return TextEditingValue(
      text: textoFormatado,
      selection: TextSelection.collapsed(offset: textoFormatado.length),
    );
  }
}

/// Formatador para horário no padrão HH:mm.
///
/// O usuário digita apenas números.
/// Exemplo: 1830 -> 18:30.
class HoraInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var texto = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (texto.length > 4) {
      texto = texto.substring(0, 4);
    }

    final buffer = StringBuffer();

    for (var i = 0; i < texto.length; i++) {
      if (i == 2) buffer.write(':');

      buffer.write(texto[i]);
    }

    final textoFormatado = buffer.toString();

    return TextEditingValue(
      text: textoFormatado,
      selection: TextSelection.collapsed(offset: textoFormatado.length),
    );
  }
}

/// Linha reutilizável com título, descrição e toggle customizado.
class _ToggleLine extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleLine({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        IosToggle(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
