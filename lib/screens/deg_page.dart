import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/geo_math.dart';

class DegPage extends StatefulWidget {
  const DegPage({super.key});
  @override
  State<DegPage> createState() => _DegPageState();
}

class _DegPageState extends State<DegPage> {
  final _degC = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _degC.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      try {
        double deg = double.parse(_degC.text.trim());
        var g = GeoMath.degToGms(deg);
        _result =
            '${g[0].toInt()}° ${g[1].toInt()}\' ${g[2].toStringAsFixed(2)}"';
      } catch (_) {
        _result = '';
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Введите корректное значение')));
      }
    });
  }

  void _clear() => setState(() {
        _degC.clear();
        _result = '';
      });

  void _copy() {
    if (_result.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _result));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Скопировано в буфер обмена')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Градусы в ГМС')),
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
                      Text('Введите десятичные градусы',
                          style:
                              Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _degC,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true, signed: true),
                        decoration: InputDecoration(
                          labelText: 'Десятичные градусы',
                          suffixText: '°',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 24),
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
                      if (_result.isNotEmpty)
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
                                SelectableText(_result,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
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