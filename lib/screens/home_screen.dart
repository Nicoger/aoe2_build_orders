import 'package:flutter/material.dart';
import '../services/language_service.dart';
import 'build_orders_screen.dart';
import 'streamers_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _lang = LanguageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_lang.translate('app_title')),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.amber),
            onPressed: () {
              setState(() {
                _lang.toggleLanguage();
              });
            },
            icon: const Icon(Icons.language, size: 20),
            label: Text(
              _lang.currentLanguage.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // BOTÓN APERTURAS (BUILD ORDERS)
            _buildMenuCard(
              context,
              title:
                  _lang.currentLanguage == 'en' ? 'BUILD ORDERS' : 'APERTURAS',
              subtitle: _lang.currentLanguage == 'en'
                  ? 'Manage & play build orders'
                  : 'Gestiona y ejecuta tus aperturas',
              icon: Icons.list_alt_rounded,
              color: Colors.amber.shade800,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BuildOrdersScreen()),
                );
              },
            ),

            const SizedBox(height: 16),

            // BOTÓN STREAMERS
            _buildMenuCard(
              context,
              title: _lang.currentLanguage == 'en'
                  ? 'PRO STREAMERS'
                  : 'STREAMERS Y PROS',
              subtitle: _lang.currentLanguage == 'en'
                  ? 'Watch top players live on Twitch'
                  : 'Mira a los mejores jugadores en directo',
              icon: Icons.live_tv_rounded,
              color: Colors.purple.shade800,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StreamersScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
          child: Row(
            children: [
              Icon(icon, size: 42, color: Colors.white),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white70, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
