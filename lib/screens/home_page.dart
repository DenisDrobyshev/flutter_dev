import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'gms_page.dart';
import 'deg_page.dart';
import 'direct_page.dart';
import 'round_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String _linkUrl =
      'https://t.me/moscowproc';

  Future<void> _openLink(BuildContext context) async {
    final Uri uri = Uri.parse(_linkUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось открыть ссылку: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
  
        title: const Text('Geodesy Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => GeodesyCalcApp.of(context)?.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: () => _openLink(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text('Geodesy Calculator',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              )),
                      const SizedBox(height: 4),
                      Text('Геодезический калькулятор',
                          style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 28),
                      _navCard(context,
                          icon: Icons.rotate_right,
                          title: 'ГМС в Десятичные градусы',
                          sub: 'Перевести в десятичные градусы',
                          page: const GmsPage()),
                      _navCard(context,
                          icon: Icons.rotate_left,
                          title: 'Десятичные градусы в ГМС',
                          sub: 'Перевод в ГГ° ММ\' СС"',
                          page: const DegPage()),
                      _navCard(context,
                          icon: Icons.arrow_forward,
                          title: 'Прямая геодезическая задача',
                          sub: 'ПГЗ: координаты в точка B',
                          page: const DirectPage()),
                      _navCard(context,
                          icon: Icons.arrow_back,
                          title: 'Обратная геодезическая задача',
                          sub: 'ОГЗ: две точки в расстояние и угол',
                          page: const RoundPage()),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('© МИИГАиК, 2026',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String sub,
      required Widget page}) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cs.outlineVariant),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => page)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: cs.onPrimaryContainer),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(sub,
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: cs.primaryContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Geodesy Cal',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cs.onPrimaryContainer)),
              ],
            ),
          ),
          _drawerTile(context, Icons.home, 'Главная', null),
          _drawerTile(context, Icons.rotate_right, 'ГМС в Градусы',
              const GmsPage()),
          _drawerTile(context, Icons.rotate_left, 'Градусы в ГМС',
              const DegPage()),
          _drawerTile(context, Icons.arrow_forward, 'Прямая задача (ПГЗ)',
              const DirectPage()),
          _drawerTile(context, Icons.arrow_back, 'Обратная задача (ОГЗ)',
              const RoundPage()),
          const Divider(),
          SwitchListTile(
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Тёмная тема'),
            value: isDark,
            onChanged: (value) {
              GeodesyCalcApp.of(context)?.setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(
      BuildContext context, IconData icon, String label, Widget? page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        if (page != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => page));
        }
      },
    );
  }
}