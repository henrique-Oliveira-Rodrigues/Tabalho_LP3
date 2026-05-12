import 'package:flutter/material.dart';

import 'widgets.dart';

class FiltrosPage extends StatefulWidget {
  const FiltrosPage({super.key});

  @override
  State<FiltrosPage> createState() => _FiltrosPageState();
}

class _FiltrosPageState extends State<FiltrosPage> {
  bool gratuito = false;
  bool inscricoesAbertas = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      gratuito = args['gratuito'] == true;
      inscricoesAbertas = args['inscricoesAbertas'] == true;
    }
  }

  void aplicarFiltros() {
    Navigator.pop(context, {
      'gratuito': gratuito,
      'inscricoesAbertas': inscricoesAbertas,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => setState(() => gratuito = !gratuito),
                          child: Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: gratuito ? Colors.black : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: gratuito ? Colors.black : Colors.grey.shade300, width: 2),
                                ),
                                child: gratuito ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                              ),
                              const SizedBox(width: 12),
                              const Text('Gratuito', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 34),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Inscrições abertas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            IosToggle(value: inscricoesAbertas, onChanged: (value) => setState(() => inscricoesAbertas = value)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(onPressed: aplicarFiltros, child: const Text('Aplicar filtros')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
