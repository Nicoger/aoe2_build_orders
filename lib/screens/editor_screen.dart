import 'package:flutter/material.dart';
import '../models/build_step.dart';
import '../services/civ_bonuses.dart';
import '../services/language_service.dart';

class EditorScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const EditorScreen({super.key, this.initialData});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final _lang = LanguageService();

  String _selectedCiv = 'generic';
  List<BuildStep> _steps = [];

  final List<String> _presetActionsKeys = [
    'Ovejas',
    'Jabalí',
    '1er jabalí',
    '2º jabalí',
    'Bayas',
    'Madera',
    'Oro',
    'Piedra',
    'Granjas',
    'Pesca',
    'Construir casa',
    'Construir molino',
    'Campamento de madera',
    'Campamento de oro',
    'Campamento de piedra',
    'Construir cuartel',
    'Construir arquería',
    'Construir establo',
    'Construir taller',
    'Herrería',
    'Mercado',
    'MODIFICABLE',
  ];

  final List<Map<String, dynamic>> _technologies = [
    {'name': 'Telar', 'time': 25.0},
    {'name': 'Collera', 'time': 40.0},
    {'name': 'Hacha doble filo', 'time': 25.0},
    {'name': 'Explotación canteras', 'time': 40.0},
    {'name': 'Minería oro', 'time': 30.0},
    {'name': 'Carretilla', 'time': 75.0},
    {'name': 'Guardia urbana', 'time': 25.0},
    {'name': 'Pureza de sangre', 'time': 40.0},
    {'name': 'Fletching', 'time': 30.0},
    {'name': 'Armadura', 'time': 40.0},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialData?['name'] ?? '',
    );
    if (widget.initialData != null) {
      _selectedCiv = widget.initialData!['civId'] ?? 'generic';
      if (widget.initialData!['steps'] != null) {
        _steps = List<BuildStep>.from(
          (widget.initialData!['steps'] as List)
              .map((e) => BuildStep.fromJson(Map<String, dynamic>.from(e))),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showVillagerDialog({BuildStep? stepToEdit, int? editIndex}) {
    String range = stepToEdit?.villagerRange ?? '';

    String selectedAction1 = _presetActionsKeys.contains(stepToEdit?.mainAction)
        ? stepToEdit!.mainAction
        : (stepToEdit?.mainAction != null
            ? 'MODIFICABLE'
            : _presetActionsKeys.first);
    String customAction1 =
        selectedAction1 == 'MODIFICABLE' ? (stepToEdit?.mainAction ?? '') : '';

    bool includeAction2 = stepToEdit?.nextActionHint != null;
    String selectedAction2 = includeAction2 &&
            _presetActionsKeys.contains(stepToEdit!.nextActionHint)
        ? stepToEdit.nextActionHint!
        : (includeAction2 ? 'MODIFICABLE' : _presetActionsKeys.first);
    String customAction2 = selectedAction2 == 'MODIFICABLE'
        ? (stepToEdit?.nextActionHint ?? '')
        : '';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: Text(editIndex != null
                ? _lang.translate('villager_dialog_title_edit')
                : _lang.translate('villager_dialog_title_add')),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: range,
                    decoration: InputDecoration(
                      labelText: _lang.translate('villager_range_label'),
                      hintText: _lang.translate('villager_range_hint'),
                    ),
                    onChanged: (val) => range = val,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedAction1,
                    decoration: InputDecoration(
                      labelText: _lang.translate('action_1_label'),
                      border: const OutlineInputBorder(),
                    ),
                    items: _presetActionsKeys.map((actionKey) {
                      return DropdownMenuItem(
                          value: actionKey,
                          child: Text(_lang.translate(actionKey)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() {
                          selectedAction1 = val;
                        });
                      }
                    },
                  ),
                  if (selectedAction1 == 'MODIFICABLE') ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: customAction1,
                      decoration: InputDecoration(
                        labelText: _lang.translate('custom_action_1'),
                      ),
                      onChanged: (val) => customAction1 = val,
                    ),
                  ],
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: Text(_lang.translate('include_action_2')),
                    value: includeAction2,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setModalState(() {
                        includeAction2 = val ?? false;
                      });
                    },
                  ),
                  if (includeAction2) ...[
                    DropdownButtonFormField<String>(
                      value: selectedAction2,
                      decoration: InputDecoration(
                        labelText: _lang.translate('action_2_label'),
                        border: const OutlineInputBorder(),
                      ),
                      items: _presetActionsKeys.map((actionKey) {
                        return DropdownMenuItem(
                            value: actionKey,
                            child: Text(_lang.translate(actionKey)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() {
                            selectedAction2 = val;
                          });
                        }
                      },
                    ),
                    if (selectedAction2 == 'MODIFICABLE') ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: customAction2,
                        decoration: InputDecoration(
                          labelText: _lang.translate('custom_action_2'),
                        ),
                        onChanged: (val) => customAction2 = val,
                      ),
                    ],
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(_lang.translate('cancel')),
              ),
              ElevatedButton(
                onPressed: () {
                  if (range.isNotEmpty) {
                    String finalAction1 = selectedAction1 == 'MODIFICABLE'
                        ? customAction1.toUpperCase()
                        : selectedAction1;

                    String? finalAction2 = includeAction2
                        ? (selectedAction2 == 'MODIFICABLE'
                            ? customAction2.toUpperCase()
                            : selectedAction2)
                        : null;

                    final newStep = BuildStep(
                      type: StepType.villager,
                      villagerRange: range,
                      mainAction: finalAction1,
                      nextActionHint: finalAction2,
                      durationInGameSecs: 25.0,
                    );

                    setState(() {
                      if (editIndex != null) {
                        _steps[editIndex] = newStep;
                      } else {
                        _steps.add(newStep);
                      }
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: Text(_lang.translate('save')),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showResearchDialog({BuildStep? stepToEdit, int? editIndex}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(editIndex != null
            ? _lang.translate('research_dialog_title_edit')
            : _lang.translate('research_dialog_title_add')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _technologies.length,
            separatorBuilder: (c, i) => const Divider(height: 1),
            itemBuilder: (ctx, idx) {
              final tech = _technologies[idx];
              final isSelected =
                  stepToEdit != null && stepToEdit.mainAction == tech['name'];

              return ListTile(
                selected: isSelected,
                selectedTileColor: Colors.blueGrey.shade800,
                title: Text(_lang.translate(tech['name']),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text('${tech['time'].toInt()}s',
                    style: const TextStyle(color: Colors.grey)),
                onTap: () {
                  final newStep = BuildStep(
                    type: StepType.research,
                    mainAction: tech['name'],
                    durationInGameSecs: tech['time'],
                  );

                  setState(() {
                    if (editIndex != null) {
                      _steps[editIndex] = newStep;
                    } else {
                      _steps.add(newStep);
                    }
                  });
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(_lang.translate('cancel')),
          ),
        ],
      ),
    );
  }

  void _showAgeDialog({BuildStep? stepToEdit, int? editIndex}) {
    String selectedAge = stepToEdit?.mainAction ?? 'FEUDAL';
    double ageDuration = stepToEdit?.durationInGameSecs ?? 130.0;

    List<RedistributionItem> tempItems = [];
    if (stepToEdit?.ageRedistribution != null) {
      for (var item in stepToEdit!.ageRedistribution!) {
        tempItems.add(RedistributionItem(
          count: item.count,
          resource: item.resource,
          note: item.note,
        ));
      }
    } else {
      tempItems = [
        RedistributionItem(count: 6, resource: 'COMIDA', note: 'Prod. Vills'),
        RedistributionItem(
            count: 4, resource: 'ORO', note: 'Scouts / Arqueros'),
        RedistributionItem(
            count: 10, resource: 'MADERA', note: 'Edificios / Granjas'),
      ];
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: Text(editIndex != null
                ? _lang.translate('age_dialog_title_edit')
                : _lang.translate('age_dialog_title_add')),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedAge,
                    decoration: InputDecoration(
                      labelText: _lang.translate('target_age'),
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                          value: 'FEUDAL',
                          child: Text(_lang.translate('FEUDAL'))),
                      DropdownMenuItem(
                          value: 'CASTILLOS',
                          child: Text(_lang.translate('CASTILLOS'))),
                      DropdownMenuItem(
                          value: 'IMPERIAL',
                          child: Text(_lang.translate('IMPERIAL'))),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() {
                          selectedAge = val;
                          if (val == 'FEUDAL') ageDuration = 130.0;
                          if (val == 'CASTILLOS') ageDuration = 160.0;
                          if (val == 'IMPERIAL') ageDuration = 190.0;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(_lang.translate('redistribution_header'),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...tempItems.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var item = entry.value;
                    return Row(
                      children: [
                        SizedBox(
                          width: 45,
                          child: TextFormField(
                            initialValue: item.count.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: _lang.translate('cant')),
                            onChanged: (val) {
                              int c = int.tryParse(val) ?? item.count;
                              tempItems[idx] = RedistributionItem(
                                  count: c,
                                  resource: item.resource,
                                  note: item.note);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: _lang.translate(item.resource),
                            decoration: InputDecoration(
                                labelText: _lang.translate('resource')),
                            onChanged: (val) {
                              tempItems[idx] = RedistributionItem(
                                  count: item.count,
                                  resource: val.toUpperCase(),
                                  note: item.note);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.redAccent),
                          onPressed: () {
                            setModalState(() {
                              tempItems.removeAt(idx);
                            });
                          },
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setModalState(() {
                        tempItems.add(RedistributionItem(
                            count: 1, resource: 'WOOD', note: ''));
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: Text(_lang.translate('add_resource')),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(_lang.translate('cancel')),
              ),
              ElevatedButton(
                onPressed: () {
                  final newStep = BuildStep(
                    type: StepType.ageUp,
                    mainAction: selectedAge,
                    durationInGameSecs: ageDuration,
                    ageRedistribution: List.from(tempItems),
                  );

                  setState(() {
                    if (editIndex != null) {
                      _steps[editIndex] = newStep;
                    } else {
                      _steps.add(newStep);
                    }
                  });
                  Navigator.pop(ctx);
                },
                child: Text(_lang.translate('save_age')),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editStep(BuildStep step, int index) {
    if (step.type == StepType.villager) {
      _showVillagerDialog(stepToEdit: step, editIndex: index);
    } else if (step.type == StepType.research) {
      _showResearchDialog(stepToEdit: step, editIndex: index);
    } else if (step.type == StepType.ageUp) {
      _showAgeDialog(stepToEdit: step, editIndex: index);
    }
  }

  void _saveBuildOrder() {
    if (_formKey.currentState!.validate()) {
      if (_steps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_lang.translate('save_validation_error'))),
        );
        return;
      }

      final buildOrderData = {
        'id': widget.initialData?['id'] ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text.trim().toUpperCase(),
        'civId': _selectedCiv,
        'steps': _steps.map((s) => s.toJson()).toList(),
      };

      Navigator.pop(context, buildOrderData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialData != null
            ? _lang.translate('edit_opening')
            : _lang.translate('new_opening')),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.greenAccent),
            onPressed: _saveBuildOrder,
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: _lang.translate('opening_name_label'),
                      hintText: _lang.translate('opening_name_hint'),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? _lang.translate('opening_name_error')
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedCiv,
                    decoration: InputDecoration(
                      labelText: _lang.translate('civ_label'),
                      border: const OutlineInputBorder(),
                    ),
                    items: CivBonuses.allCivs.map((civ) {
                      return DropdownMenuItem<String>(
                        value: civ['id'],
                        child: Text(civ['name']!),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCiv = val);
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showVillagerDialog(),
                    icon: const Icon(Icons.person_add),
                    label: Text(_lang.translate('btn_add_villager')),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[800]),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _showResearchDialog(),
                    icon: const Icon(Icons.science),
                    label: Text(_lang.translate('btn_research')),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _showAgeDialog(),
                    icon: const Icon(Icons.castle),
                    label: Text(_lang.translate('btn_age')),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: _steps.isEmpty
                  ? Center(
                      child: Text(_lang.translate('empty_editor_steps'),
                          style: const TextStyle(color: Colors.grey)),
                    )
                  : ReorderableListView.builder(
                      itemCount: _steps.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex -= 1;
                          final item = _steps.removeAt(oldIndex);
                          _steps.insert(newIndex, item);
                        });
                      },
                      itemBuilder: (ctx, index) {
                        final step = _steps[index];
                        final displayTitle = _lang.translate(step.mainAction);

                        return Card(
                          key: ValueKey(index),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          color: step.type == StepType.ageUp
                              ? Colors.indigo.shade900
                              : (step.type == StepType.research
                                  ? Colors.grey.shade900
                                  : Colors.blueGrey.shade900),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.amber,
                              child: Text(
                                step.type == StepType.villager
                                    ? step.villagerRange ?? '1'
                                    : (step.type == StepType.ageUp
                                        ? '🏰'
                                        : '🧵'),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            ),
                            title: Text(displayTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: step.nextActionHint != null
                                ? Text(
                                    '${_lang.translate('action_2_label')}: ${_lang.translate(step.nextActionHint!)}')
                                : (step.ageRedistribution != null
                                    ? Text(
                                        '${_lang.translate('redistribution_subtitle')} (${step.ageRedistribution!.length} ${_lang.translate('resources')})')
                                    : null),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.amberAccent),
                                  onPressed: () => _editStep(step, index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    setState(() {
                                      _steps.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      ),  
    );
  }
}
