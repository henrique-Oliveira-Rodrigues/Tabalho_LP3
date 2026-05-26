import 'package:flutter/material.dart';
<<<<<<< HEAD

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

=======
import '../widgets/ios_toggle.dart';

>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
class FiltrosScreen extends StatefulWidget {
  const FiltrosScreen({super.key});

  @override
  State<FiltrosScreen> createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  bool gratuito = false;
  bool inscricoesAbertas = false;
  String? bairro;

<<<<<<< HEAD
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

=======
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
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
=======
        title: const Text('Filtros', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Expanded(
<<<<<<< HEAD
                  child: SingleChildScrollView(
=======
                  child: Padding(
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => setState(() => gratuito = !gratuito),
<<<<<<< HEAD
                          borderRadius: BorderRadius.circular(8),
=======
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
                          child: Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: gratuito ? Colors.black : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
<<<<<<< HEAD
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
=======
                                  border: Border.all(color: gratuito ? Colors.black : Colors.grey.shade300, width: 2),
                                ),
                                child: gratuito ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                              ),
                              const SizedBox(width: 12),
                              const Text('Gratuito', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
                            ],
                          ),
                        ),
                        const SizedBox(height: 34),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
<<<<<<< HEAD
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
=======
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
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
                          ],
                          onChanged: (value) => setState(() => bairro = value),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
<<<<<<< HEAD
                  child: ElevatedButton(
                    onPressed: aplicarFiltros,
                    child: const Text('Aplicar filtros'),
                  ),
=======
                  child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Aplicar filtros')),
>>>>>>> 9ffcc5e17a99758125bd943d392497ac5c46617c
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
