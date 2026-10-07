import 'dart:async';
import 'dart:convert';
import 'dart:io'; // Para manejar conexiones de red local UDP
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/build_step.dart';
import '../services/civ_bonuses.dart';
import '../services/language_service.dart';

class PlayScreen extends StatefulWidget {
  final Map<String, dynamic> buildOrder;

  const PlayScreen({super.key, required this.buildOrder});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  late List<BuildStep> _steps;
  int _currentStepIndex = 0;

  bool _isPlaying = false;
  Timer? _timer;

  double _elapsedTotalSecs = 0;
  double _stepRemainingSecs = 0;
  String _selectedSpeedMode = 'Normal';

  // Variables para la lógica del contador de aldeanos (vills)
  int _currentVillagers = 3;
  int _totalBuildVillagers = 21;
  double _villagerAccumulator = 0.0;

  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  final _lang = LanguageService();

  // Socket para escuchar el trigger desde la PC
  RawDatagramSocket? _udpSocket;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    _steps = List<BuildStep>.from(
      (widget.buildOrder['steps'] as List)
          .map((e) => BuildStep.fromJson(Map<String, dynamic>.from(e))),
    );

    _setupVillagers();
    _initCurrentStepDuration();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _blinkAnimation =
        Tween<double>(begin: 0.3, end: 1.0).animate(_blinkController);

    // Iniciar el oyente de red para recibir el inicio desde la PC
    _startUdpListener();
  }

  void _setupVillagers() {
    final currentCiv =
        (widget.buildOrder['civId'] ?? 'generic').toString().toLowerCase();

    // 1. Detectar aldeanos de inicio según la civilización
    int startingVills = 3; // Estándar
    if (currentCiv.contains('chinese') || currentCiv.contains('chino')) {
      startingVills = 6;
    } else if (currentCiv.contains('mayan') || currentCiv.contains('maya')) {
      startingVills = 4;
    }

    // 2. Si la orden trae un rango en el primer paso (ej. "4-6" o "7-9")
    if (_steps.isNotEmpty) {
      final firstStep = _steps.first;
      if (firstStep.villagerRange != null &&
          firstStep.villagerRange!.contains('-')) {
        final parts = firstStep.villagerRange!.split('-');
        int startRange = int.tryParse(parts[0].trim()) ?? (startingVills + 1);
        _currentVillagers = startRange - 1;
      } else {
        _currentVillagers = startingVills;
      }
    } else {
      _currentVillagers = startingVills;
    }

    // 3. Encontrar el total máximo de aldeanos de la Build Order
    int maxVills = _currentVillagers;
    for (var step in _steps) {
      if (step.villagerRange != null) {
        final matches = RegExp(r'\d+').allMatches(step.villagerRange!);
        for (var match in matches) {
          int val = int.parse(match.group(0)!);
          if (val > maxVills) maxVills = val;
        }
      }
    }
    _totalBuildVillagers = maxVills;
  }

  void _startUdpListener() async {
    try {
      // Escucha en el puerto 44444 en la red Wi-Fi local
      _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 44444);
      _udpSocket?.broadcastEnabled = true;

      _udpSocket?.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? dg = _udpSocket?.receive();
          if (dg != null) {
            String message = utf8.decode(dg.data).trim();
            if (message == "START" || message == "GO") {
              if (!_isPlaying && mounted) {
                _togglePlayPause();
              }
            }
          }
        }
      });
    } catch (e) {
      debugPrint("Error escuchando puerto UDP: $e");
    }
  }

  String _getCurrentAgeState() {
    String currentAge = 'DARK';
    for (int i = 0; i <= _currentStepIndex; i++) {
      if (_steps[i].type == StepType.ageUp) {
        currentAge = _steps[i].mainAction;
      }
    }
    return currentAge;
  }

  void _initCurrentStepDuration() {
    if (_steps.isNotEmpty) {
      final currentCiv = widget.buildOrder['civId'] ?? 'generic';
      final currentAge = _getCurrentAgeState();

      _stepRemainingSecs = CivBonuses.getAdjustedStepDuration(
        _steps[_currentStepIndex],
        currentCiv,
        currentAge,
      );
    }
  }

  @override
  void dispose() {
    _udpSocket?.close(); // Cerramos el socket al salir
    WakelockPlus.disable();
    _timer?.cancel();
    _blinkController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _elapsedTotalSecs = 0;
      _currentStepIndex = 0;
      _villagerAccumulator = 0.0;
      _setupVillagers();
      _initCurrentStepDuration();
    });
  }

  void _restartTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedTotalSecs = 0;
      _currentStepIndex = 0;
      _villagerAccumulator = 0.0;
      _setupVillagers();
      _initCurrentStepDuration();
      _isPlaying = true;
    });
    _startTimer();
  }

  void _addSeconds(double seconds) {
    setState(() {
      _stepRemainingSecs = (_stepRemainingSecs + seconds).clamp(0.0, 9999.0);
    });
  }

  void _startTimer() {
    _timer?.cancel();
    double multiplier = CivBonuses.getGameSpeedMultiplier(_selectedSpeedMode);
    int intervalMs = (1000 / multiplier).round();

    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (!mounted) return;
      setState(() {
        _elapsedTotalSecs += 1.0;

        // Acumular tiempo para creación automática de aldeanos (25 segundos por vill en AoE2)
        if (_currentVillagers < _totalBuildVillagers) {
          _villagerAccumulator += 1.0;
          if (_villagerAccumulator >= 25.0) {
            _currentVillagers++;
            _villagerAccumulator -= 25.0;
          }
        }

        if (_stepRemainingSecs > 0) {
          _stepRemainingSecs -= 1.0;
        } else {
          _nextStep();
        }
      });
    });
  }

  void _nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _initCurrentStepDuration();
      });
    } else {
      _timer?.cancel();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
        _initCurrentStepDuration();
      });
    }
  }

  String _formatGameTime(double seconds) {
    int mins = (seconds / 60).floor();
    int secs = (seconds % 60).floor();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _getFormattedStatus(BuildStep step) {
    final actionTranslated = _lang.translate(step.mainAction).toUpperCase();
    if (step.type == StepType.research) {
      return '${_lang.translate('developing')} $actionTranslated';
    } else if (step.type == StepType.ageUp) {
      return '${_lang.translate('advancing_to')} $actionTranslated';
    } else {
      return actionTranslated;
    }
  }

  bool _isImportantStep(BuildStep? step) {
    if (step == null) return false;
    return step.type == StepType.research || step.type == StepType.ageUp;
  }

  List<String> get _speedModes {
    return _lang.currentLanguage == 'en'
        ? ['Slow', 'Casual', 'Normal', 'Fast']
        : ['Lenta', 'Casual', 'Normal', 'Rápida'];
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _steps[_currentStepIndex];
    final nextStep = _currentStepIndex < _steps.length - 1
        ? _steps[_currentStepIndex + 1]
        : null;
    final isNextImportant = _isImportantStep(nextStep);

    final bool hasSecondAction = currentStep.nextActionHint != null &&
        currentStep.nextActionHint!.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.buildOrder['name'] ?? _lang.translate('playback_title')),
        actions: [
          DropdownButton<String>(
            value: _speedModes.contains(_selectedSpeedMode)
                ? _selectedSpeedMode
                : _speedModes[2],
            dropdownColor: Colors.grey[900],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            underline: Container(),
            items: _speedModes.map((m) {
              return DropdownMenuItem(
                  value: m,
                  child: Text('${_lang.translate('speed_label')}: $m'));
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedSpeedMode = val;
                });
                if (_isPlaying) _startTimer();
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // PANEL DE TIEMPO PRINCIPAL
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.black45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1. IZQUIERDA: Contador de Aldeanos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ALDEANOS',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          '$_currentVillagers/$_totalBuildVillagers',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. CENTRO: Tiempo Total
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'TIEMPO TOTAL',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          _formatGameTime(_elapsedTotalSecs),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. DERECHA: Restante Paso
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'RESTANTE PASO',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          _formatGameTime(_stepRemainingSecs),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // PASO ACTUAL
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 6,
                        color: Colors.grey.shade900,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.greenAccent, width: 2.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              if (currentStep.type == StepType.villager &&
                                  currentStep.villagerRange != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Aldeanos: ${currentStep.villagerRange}',
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber),
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],

                              // PRIMERA ACCIÓN (1-->)
                              Text(
                                hasSecondAction
                                    ? '1--> ${_getFormattedStatus(currentStep)}'
                                    : _getFormattedStatus(currentStep),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),

                              // SEGUNDA ACCIÓN (2--->)
                              if (hasSecondAction) ...[
                                const SizedBox(height: 10),
                                Text(
                                  '2---> ${_lang.translate(currentStep.nextActionHint!)}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyanAccent),
                                ),
                              ],

                              if (currentStep.ageRedistribution != null) ...[
                                const Divider(height: 16),
                                Text(
                                  _lang.translate('task_redistribution_header'),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amberAccent,
                                      fontSize: 12),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: currentStep.ageRedistribution!
                                      .map((item) => Chip(
                                            backgroundColor: Colors.black54,
                                            label: Text(
                                              '${item.count} -> ${_lang.translate(item.resource)}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // SIGUIENTE PASO
                    if (nextStep != null)
                      AnimatedBuilder(
                        animation: _blinkAnimation,
                        builder: (context, child) {
                          final opacity =
                              isNextImportant ? _blinkAnimation.value : 1.0;
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isNextImportant
                                  ? Colors.redAccent.withOpacity(opacity)
                                  : Colors.black26,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isNextImportant
                                    ? Colors.red.withOpacity(opacity)
                                    : Colors.white24,
                                width: isNextImportant ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _getFormattedStatus(nextStep),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                if (nextStep.villagerRange != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Aldeanos: ${nextStep.villagerRange}',
                                    style: const TextStyle(
                                        color: Colors.amberAccent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ]
                              ],
                            ),
                          );
                        },
                      ),

                    // LISTA DE PASOS QUE SIGUEN DESPUÉS
                    if (_currentStepIndex + 2 < _steps.length) ...[
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = _currentStepIndex + 2;
                                i < _steps.length;
                                i++) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_right_rounded,
                                        size: 20, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        _getFormattedStatus(_steps[i]),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    if (_steps[i].villagerRange != null)
                                      Text(
                                        'Aldeanos: ${_steps[i].villagerRange}',
                                        style: const TextStyle(
                                          color: Colors.amberAccent,
                                          fontSize: 13,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (i < _steps.length - 1)
                                const Divider(color: Colors.white10, height: 1),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // CONTROLES INFERIORES
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black45,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.replay_5, color: Colors.grey),
                        onPressed: () => _addSeconds(-5),
                      ),
                      IconButton(
                        iconSize: 40,
                        icon: const Icon(Icons.skip_previous,
                            color: Colors.amber),
                        onPressed: _prevStep,
                      ),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: FloatingActionButton(
                          backgroundColor:
                              _isPlaying ? Colors.orange : Colors.green,
                          onPressed: _togglePlayPause,
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 42,
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 40,
                        icon: const Icon(Icons.skip_next, color: Colors.amber),
                        onPressed: _nextStep,
                      ),
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.forward_5, color: Colors.grey),
                        onPressed: () => _addSeconds(5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: _restartTimer,
                        icon: const Icon(Icons.restart_alt, size: 18),
                        label: Text(_lang.translate('btn_restart')),
                      ),
                      TextButton.icon(
                        onPressed: _stopTimer,
                        icon: const Icon(Icons.stop,
                            color: Colors.redAccent, size: 18),
                        label: Text(
                          _lang.translate('btn_stop'),
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
