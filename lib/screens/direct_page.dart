import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/geo_math.dart';

class DirectPage extends StatefulWidget {
  const DirectPage({super.key});
  @override
  State<DirectPage> createState() => _DirectPageState();
}

class _DirectPageState extends State<DirectPage> {
  final _xaC = TextEditingController();
  final _yaC = TextEditingController();
  final _dC = TextEditingController();
  final _degC = TextEditingController();
  final _minC = TextEditingController();
  final _secC = TextEditingController();
  String _res = '';

  @override
  void dispose() {
    for (var c in [_xaC, _yaC, _dC, _degC, _minC, _secC]) {
      c.dispose();
    }
    super.dispose();
  }

  void _calculate() {
    setState(() {
      try {
        double xa = double.parse(_xaC.text.trim());
        double ya = double.parse(_yaC.text.trim());
        double d = double.parse(_dC.text.trim());
        int deg = int.parse(_degC.text.trim());
        int min = int.parse(_minC.text.trim());
        double sec = double.parse(_secC.text.trim());

        var r = GeoMath.directProblem(xa, ya, d, deg, min, sec);

        _res = 'Xb = ${r['Xb']!.toStringAsFixed(2)} м\n'
            'Yb = ${r['Yb']!.toStringAsFixed(2)} м\n\n'
            'ΔX = ${r['deltaX']!.toStringAsFixed(2)} м\n'
            'ΔY = ${r['deltaY']!.toStringAsFixed(2)} м';
      } catch (_) {
        _res = '';
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Заполните все поля корректно')));
      }
    });
  }

  void _clear() => setState(() {
        for (var c in [_xaC, _yaC, _dC, _degC, _minC, _secC]) {
          c.clear();
        }
        _res = '';
      });

  void _copy() {
    if (_res.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _res));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Скопировано')));
  }

  InputDecoration _dec(String label, {String? suf}) => InputDecoration(
        labelText: label,
        suffixText: suf,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)),
      );

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(title: const Text('Прямая задача (ПГЗ)')),
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
                      Row(children: [
                        Expanded(
                            child: TextField(
                                controller: _xaC,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: true),
                                decoration: _dec('X_A', suf: 'м'))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: TextField(
                                controller: _yaC,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: true),
                                decoration: _dec('Y_A', suf: 'м'))),
                      ]),
                      const SizedBox(height: 18),
                      Text('Горизонтальное проложение', style: title),
                      const SizedBox(height: 12),
                      TextField(
                          controller: _dC,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                                  decimal: true),
                          decoration: _dec('d', suf: 'м')),
                      const SizedBox(height: 18),
                      Text('Дирекционный угол α', style: title),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                            child: TextField(
                                controller: _degC,
                                keyboardType: TextInputType.number,
                                decoration: _dec('ГГ', suf: '°'))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: TextField(
                                controller: _minC,
                                keyboardType: TextInputType.number,
                                decoration: _dec('ММ', suf: "'"))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: TextField(
                                controller: _secC,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: _dec('СС', suf: '"'))),
                      ]),
                      const SizedBox(height: 24),
                      // Кнопки
                      Row(children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _calculate,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                            ),
                            child: const Text('РАССЧИТАТЬ',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _clear,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(50, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                          child: const Icon(Icons.clear),
                        ),
                      ]),
                      const SizedBox(height: 28),
                      // Результат
                      if (_res.isNotEmpty)
                        Card(
                          elevation: 0,
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Результат',
                                        style: TextStyle(
                                            color: Colors.grey[700])),
                                    IconButton(
                                        icon: const Icon(Icons.copy),
                                        onPressed: _copy),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                SelectableText(_res,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        height: 1.6)),
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
                child: Text('© МИИГАиК, 2026',
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}