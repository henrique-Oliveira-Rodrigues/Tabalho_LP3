import 'package:flutter/material.dart';

import '../widgets/ios_toggle.dart';

class FiltrosEventos {
  final bool gratuito;
  final bool inscricoesAbertas;
  final String? bairro;

  const FiltrosEventos({
    required this.gratuito,
    required this.inscricoesAbertas,
    this.bairro,
  });

  // Facilita a verificação se algum filtro está ativo.
  bool get possuiFiltroAtivo => gratuito || inscricoesAbertas || bairro != null;
}

class FiltrosScreen extends StatefulWidget {
  const FiltrosScreen({super.key});

  @override
  State<FiltrosScreen> createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  bool gratuito = false;
  bool inscricoesAbertas = false;
  String? bairro;

  void aplicarFiltros() {
    // Retorna os filtros escolhidos para a tela anterior.
    Navigator.pop(
      context,
      FiltrosEventos(
        gratuito: gratuito,
        inscricoesAbertas: inscricoesAbertas,
        bairro: bairro,
      ),
    );
  }

  void limparFiltros() {
    setState(() {
      gratuito = false;
      inscricoesAbertas = false;
      bairro = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Filtros',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: limparFiltros,
            child: const Text('Limpar'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => setState(() => gratuito = !gratuito),
                          borderRadius: BorderRadius.circular(8),
                          child: Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: gratuito ? Colors.black : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: gratuito
                                        ? Colors.black
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: gratuito
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Gratuito',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 34),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Inscrições abertas',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IosToggle(
                              value: inscricoesAbertas,
                              onChanged: (value) {
                                setState(() => inscricoesAbertas = value);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 34),
                        const Text(
                          'Bairro',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: bairro,
                          decoration: const InputDecoration(
                            hintText: 'Selecione o bairro',
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Centro', child: Text('Centro')),
                            DropdownMenuItem(value: 'Zona Sul', child: Text('Zona Sul')),
                            DropdownMenuItem(value: 'Zona Norte', child: Text('Zona Norte')),
                            DropdownMenuItem(value: 'Outro', child: Text('Outro')),
                          ],
                          onChanged: (value) => setState(() => bairro = value),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: aplicarFiltros,
                    child: const Text('Aplicar filtros'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
