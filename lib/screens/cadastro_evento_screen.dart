import 'package:flutter/material.dart';
import '../widgets/ios_toggle.dart';

class CadastroEventoScreen extends StatefulWidget {
  const CadastroEventoScreen({super.key});

  @override
  State<CadastroEventoScreen> createState() => _CadastroEventoScreenState();
}

class _CadastroEventoScreenState extends State<CadastroEventoScreen> {
  bool gratuito = false;
  bool inscricoesAbertas = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Evento', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const _Field(label: 'Título do Evento', hint: 'Ex: Workshop de Fotografia'),
                  const SizedBox(height: 18),
                  const _Field(label: 'Descrição', hint: 'Conte mais sobre o evento...', maxLines: 4),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Expanded(child: _Field(label: 'Data', hint: 'dd/mm/aaaa')),
                      SizedBox(width: 14),
                      Expanded(child: _Field(label: 'Horário', hint: '00:00')),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const _Field(label: 'Local', hint: 'Ex: Praça Central'),
                  const SizedBox(height: 18),
                  const _Field(label: 'Link de Inscrição', hint: 'https://...', keyboardType: TextInputType.url),
                  const SizedBox(height: 24),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 18),
                  _ToggleLine(
                    title: 'Gratuito',
                    subtitle: 'O evento não tem custo',
                    value: gratuito,
                    onChanged: (value) => setState(() => gratuito = value),
                  ),
                  const SizedBox(height: 22),
                  _ToggleLine(
                    title: 'Inscrições abertas',
                    subtitle: 'Permitir inscrições agora',
                    value: inscricoesAbertas,
                    onChanged: (value) => setState(() => inscricoesAbertas = value),
                  ),
                  const SizedBox(height: 34),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

  const _Field({required this.label, required this.hint, this.maxLines = 1, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(maxLines: maxLines, keyboardType: keyboardType, decoration: InputDecoration(hintText: hint)),
      ],
    );
  }
}

class _ToggleLine extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleLine({required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
        IosToggle(value: value, onChanged: onChanged),
      ],
    );
  }
}
