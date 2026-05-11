import 'package:flutter/material.dart';
import '../widgets/ios_toggle.dart';

class FiltrosScreen extends StatefulWidget {
  const FiltrosScreen({super.key});

  @override
  State<FiltrosScreen> createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  bool gratuito = false;
  bool inscricoesAbertas = false;
  String? bairro;

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
                        const SizedBox(height: 34),
                        const Text('Bairro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: bairro,
                          decoration: const InputDecoration(hintText: 'Selecione o bairro'),
                          items: const [
                            DropdownMenuItem(value: 'centro', child: Text('Centro')),
                            DropdownMenuItem(value: 'zona-sul', child: Text('Zona Sul')),
                            DropdownMenuItem(value: 'zona-norte', child: Text('Zona Norte')),
                          ],
                          onChanged: (value) => setState(() => bairro = value),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Aplicar filtros')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
