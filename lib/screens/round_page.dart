import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/geo_math.dart';

class RoundPage extends StatefulWidget {
  const RoundPage({super.key});
  @override
  State<RoundPage> createState() => _RoundPageState();
}

class _RoundPageState extends State<RoundPage> {
  final _xaC = TextEditingController();
  final _yaC = TextEditingController();
  final _xbC = TextEditingController();
  final _ybC = TextEditingController();
  String _res = '';

  @override
  void dispose() {
    for (var c in [_xaC, _yaC, _xbC, _ybC]) {
      c.dispose();
    }
    super.dispose();
  }

  String _fmtGms(List<double> g) =>
      '${g[0].toInt()}° ${g[1].toInt()}\' ${g[2].round()}"';

  void _calculate() {
    setState(() {
      try {
        double xa = double.parse(_xaC.text.trim());
        double ya = double.parse(_yaC.text.trim());
        double xb = double.parse(_xbC.text.trim());
        double yb = double.parse(_ybC.text.trim());

        var r = GeoMath.inverseProblem(xa, ya, xb, yb);

        double d = r['d'];
        double dx = r['deltaX'];
        double dy = r['deltaY'];
        String dir = r['direction'];
        List<double> rGms = r['rGms'];
        List<double> aGms = r['alphaGms'];

        _res =
            'D = ${d.toStringAsFixed(2)} м\n'
            'ΔX = ${dx.toStringAsFixed(2)} м\n'
            'ΔY = ${dy.toStringAsFixed(2)} м\n'
            'Румб r = ${_fmtGms(rGms)} ($dir)\n'
            'Дирекц. угол α = ${_fmtGms(aGms)}';
      } catch (_) {
        _res = '';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заполните все поля корректно')),
        );
      }
    });
  }

  void _clear() => setState(() {
    for (var c in [_xaC, _yaC, _xbC, _ybC]) {
      c.clear();
    }
    _res = '';
  });

  void _copy() {
    if (_res.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _res));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Скопировано')));
  }

  InputDecoration _dec(String label) => InputDecoration(
    labelText: label,
    suffixText: 'м',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(title: const Text('Обратная задача (ОГЗ)')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Координаты точки A', style: title),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _xaC,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              decoration: _dec('X_A'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _yaC,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              decoration: _dec('Y_A'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text('Координаты точки B', style: title),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _xbC,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              decoration: _dec('X_B'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _ybC,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              decoration: _dec('Y_B'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _calculate,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'РАССЧИТАТЬ',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _clear,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(50, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Icon(Icons.clear),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      if (_res.isNotEmpty)
                        Card(
                          elevation: 0,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Результат',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy),
                                      onPressed: _copy,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                SelectableText(
                                  _res,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '© МИИГАиК, 2026',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
