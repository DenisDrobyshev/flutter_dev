import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/geo_math.dart';

class GmsPage extends StatefulWidget {
  const GmsPage({super.key});
  @override
  State<GmsPage> createState() => _GmsPageState();
}

class _GmsPageState extends State<GmsPage> {
  final _ggC = TextEditingController();
  final _mmC = TextEditingController();
  final _ssC = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _ggC.dispose();
    _mmC.dispose();
    _ssC.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      try {
        int gg = int.parse(_ggC.text.trim());
        int mm = int.parse(_mmC.text.trim());
        double ss = double.parse(_ssC.text.trim());
        double deg = GeoMath.gmsToDeg(gg, mm, ss);
        _result = deg.toStringAsFixed(10);
      } catch (_) {
        _result = '';
        _showError();
      }
    });
  }

  void _clear() => setState(() {
        _ggC.clear();
        _mmC.clear();
        _ssC.clear();
        _result = '';
      });

  void _copy() {
    if (_result.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _result));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Скопировано в буфер обмена')));
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Пожалуйста, заполните все поля корректно')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ГМС в Десятичные градусы')),
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
                      Text('Введите значение в формате ГГ° ММ\' СС"',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 20),
                      Row(children: [
                        _field(_ggC, 'ГГ', '°'),
                        const SizedBox(width: 10),
                        _field(_mmC, 'ММ', "'"),
                        const SizedBox(width: 10),
                        _field(_ssC, 'СС', '"', decimal: true),
                      ]),
                      const SizedBox(height: 24),
                      _buttons(),
                      const SizedBox(height: 28),
                      if (_result.isNotEmpty) _resultCard('$_result°'),
                    ],
                  ),
                ),
              ),
              _footer(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Вспомогательные виджеты ──

  Widget _field(TextEditingController c, String label, String suffix,
      {bool decimal = false}) {
    return Expanded(
      child: TextField(
        controller: c,
        keyboardType: decimal
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buttons() => Row(children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _calculate,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child:
                const Text('РАССЧИТАТЬ', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _clear,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(50, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: const Icon(Icons.clear),
        ),
      ]);

  Widget _resultCard(String text) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Результат',
                    style: TextStyle(color: Colors.grey[700])),
                IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _copy,
                    tooltip: 'Копировать'),
              ],
            ),
            const SizedBox(height: 4),
            SelectableText(text,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _footer() => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text('© МИИГАиК, 2026',
            style: TextStyle(color: Colors.grey[500], fontSize: 13)),
      );
}