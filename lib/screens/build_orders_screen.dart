import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/language_service.dart';
import 'editor_screen.dart';
import 'play_screen.dart';

class BuildOrdersScreen extends StatefulWidget {
  const BuildOrdersScreen({super.key});

  @override
  State<BuildOrdersScreen> createState() => _BuildOrdersScreenState();
}

class _BuildOrdersScreenState extends State<BuildOrdersScreen> {
  late Box _buildOrdersBox;
  bool _isLoading = true;
  final _lang = LanguageService();

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _buildOrdersBox = await Hive.openBox('build_orders');
    setState(() {
      _isLoading = false;
    });
  }

  void _createNewBuildOrder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditorScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      await _buildOrdersBox.put(result['id'], result);
    }
  }

  void _editBuildOrder(dynamic key, Map<String, dynamic> data) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorScreen(initialData: data),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      await _buildOrdersBox.put(key, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(_lang.currentLanguage == 'en' ? 'BUILD ORDERS' : 'APERTURAS'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _buildOrdersBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text(
                _lang.translate('empty_build_orders'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final key = box.keyAt(index);
              final item = Map<String, dynamic>.from(box.get(key));
              final steps = (item['steps'] as List? ?? []);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    item['name'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                  subtitle: Text(
                      '${_lang.translate('steps_count')}: ${steps.length}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.amber),
                        onPressed: () => _editBuildOrder(key, item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_circle_fill,
                            color: Colors.greenAccent, size: 36),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => PlayScreen(
                                buildOrder: Map<String, dynamic>.from(item),
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _buildOrdersBox.delete(key),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: _createNewBuildOrder,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
