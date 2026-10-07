import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/language_service.dart';

class StreamersScreen extends StatelessWidget {
  const StreamersScreen({super.key});

  final List<Map<String, String>> _streamers = const [
    {
      'name': 'Hera',
      'role': 'Pro Player #1 (Canada)',
      'url': 'https://www.twitch.tv/hera',
      'avatar': 'H',
    },
    {
      'name': 'TheViper',
      'role': 'Legendary Pro (Norway)',
      'url': 'https://www.twitch.tv/theviper',
      'avatar': 'V',
    },
    {
      'name': 'T90Official',
      'role': 'Caster & Community Hub (USA)',
      'url': 'https://www.twitch.tv/t90official',
      'avatar': 'T',
    },
    {
      'name': 'MembTV',
      'role': 'Hidden Cup / Tournament Caster',
      'url': 'https://www.twitch.tv/membtv',
      'avatar': 'M',
    },
    {
      'name': 'Nacho_AoE',
      'role': 'Top Pro & Streamer (Argentina)',
      'url': 'https://www.twitch.tv/nacho_aoe',
      'avatar': 'N',
    },
    {
      'name': 'TaToH',
      'role': 'Pro Player & caster (Spain)',
      'url': 'https://www.twitch.tv/tatohaoe',
      'avatar': 'TT',
    },
  ];

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageService();
    final isEn = lang.currentLanguage == 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(isEn ? 'PRO STREAMERS' : 'STREAMERS Y PROS'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _streamers.length,
        itemBuilder: (context, index) {
          final streamer = _streamers[index];
          return Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.amberAccent, width: 1),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.amber,
                child: Text(
                  streamer['avatar']!,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                streamer['name']!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
              subtitle: Text(
                streamer['role']!,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.live_tv,
                    color: Colors.purpleAccent, size: 28),
                onPressed: () => _launchURL(streamer['url']!),
              ),
              onTap: () => _launchURL(streamer['url']!),
            ),
          );
        },
      ),
    );
  }
}
