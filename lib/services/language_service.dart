import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  String _currentLanguage = 'es';

  String get currentLanguage => _currentLanguage;

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == 'es' ? 'en' : 'es';
    notifyListeners();
  }

  void setLanguage(String lang) {
    if (lang == 'es' || lang == 'en') {
      _currentLanguage = lang;
      notifyListeners();
    }
  }

  String translate(String key) {
    return _localizedValues[_currentLanguage]?[key] ?? key;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'es': {
      'app_title': 'AOE2 Build Order',
      'empty_build_orders':
          'No hay aperturas creadas.\nToca el botón + para añadir una.',
      'steps_count': 'Pasos',

      // Editor Screen
      'edit_opening': 'Editar Apertura',
      'new_opening': 'Nueva Apertura',
      'opening_name_label': 'Nombre de la Apertura',
      'opening_name_hint': 'Ej: SCOUT RUSH - FRANCOS',
      'opening_name_error': 'Escribe un nombre',
      'civ_label': 'Civilización',
      'btn_add_villager': '+ Aldeano(s)',
      'btn_research': 'Desarrollar',
      'btn_age': 'Edad',
      'empty_editor_steps': 'Agrega pasos usando los botones de arriba',
      'action_2_label': 'Acción 2',
      'redistribution_subtitle': 'Reasignación',
      'resources': 'recursos',
      'save_validation_error': 'Añade al menos un paso a la secuencia.',

      // Diálogos de Editor
      'villager_dialog_title_add': 'Añadir Aldeano(s)',
      'villager_dialog_title_edit': 'Modificar Línea de Aldeanos',
      'villager_range_label': 'Número o Rango de Aldeano(s)',
      'villager_range_hint': 'Ej: 1-6 ó 7',
      'action_1_label': 'Acción 1',
      'custom_action_1': 'Escribe tu acción personalizada 1',
      'include_action_2': '¿Añadir Acción 2 (Próxima)?',
      'custom_action_2': 'Escribe tu acción personalizada 2',
      'research_dialog_title_add': 'Selecciona Desarrollo',
      'research_dialog_title_edit': 'Modificar Desarrollo',
      'age_dialog_title_add': 'Avanzar de Edad y Reasignación',
      'age_dialog_title_edit': 'Modificar Edad y Reasignación',
      'target_age': 'Edad Objetivo',
      'redistribution_header': 'Reasignación de aldeanos al clickear:',
      'cant': 'Cant.',
      'resource': 'Recurso',
      'add_resource': 'Agregar Recurso',
      'cancel': 'Cancelar',
      'save': 'Guardar',
      'save_age': 'Guardar Edad',

      // Play Screen
      'playback_title': 'REPRODUCCIÓN',
      'speed_label': 'Vel',
      'current_task_title': 'TAREA ACTUAL',
      'villagers_count_label': 'ALDEANO(S)',
      'next_action_hint': 'Próxima acción',
      'task_redistribution_header': 'REASIGNACIÓN DE TAREAS:',
      'next_task_prefix': 'PRÓXIMO',
      'developing': 'DESARROLLANDO',
      'advancing_to': 'AVANZANDO A',
      'btn_restart': 'Reiniciar',
      'btn_stop': 'Detener',

      // Speeds
      'speed_slow': 'Lenta',
      'speed_casual': 'Casual',
      'speed_normal': 'Normal',
      'speed_fast': 'Rápida',

      // Actions / Preset Items
      'Ovejas': 'Ovejas',
      'Jabalí': 'Jabalí',
      '1er jabalí': '1er jabalí',
      '2º jabalí': '2º jabalí',
      'Bayas': 'Bayas',
      'Madera': 'Madera',
      'Oro': 'Oro',
      'Piedra': 'Piedra',
      'Granjas': 'Granjas',
      'Pesca': 'Pesca',
      'Construir casa': 'Construir casa',
      'Construir molino': 'Construir molino',
      'Campamento de madera': 'Campamento de madera',
      'Campamento de oro': 'Campamento de oro',
      'Campamento de piedra': 'Campamento de piedra',
      'Construir cuartel': 'Construir cuartel',
      'Construir arquería': 'Construir arquería',
      'Construir establo': 'Construir establo',
      'Construir taller': 'Construir taller',
      'Herrería': 'Herrería',
      'Mercado': 'Mercado',
      'MODIFICABLE': 'MODIFICABLE',

      // Techs
      'Telar': 'Telar',
      'Collera': 'Collera',
      'Hacha doble filo': 'Hacha doble filo',
      'Explotación canteras': 'Explotación canteras',
      'Minería oro': 'Minería oro',
      'Carretilla': 'Carretilla',
      'Guardia urbana': 'Guardia urbana',
      'Pureza de sangre': 'Pureza de sangre',
      'Fletching': 'Fletching',
      'Armadura': 'Armadura',

      // Ages
      'FEUDAL': 'EDAD FEUDAL (II)',
      'CASTILLOS': 'ED. CASTILLOS (III)',
      'IMPERIAL': 'EDAD IMPERIAL (IV)',

      // Resources
      'COMIDA': 'COMIDA',
      'MADERA': 'MADERA',
      'ORO': 'ORO',
      'PIEDRA': 'PIEDRA',
    },
    'en': {
      'app_title': 'AOE2 Build Order',
      'empty_build_orders': 'No build orders created.\nTap + to add one.',
      'steps_count': 'Steps',

      // Editor Screen
      'edit_opening': 'Edit Build Order',
      'new_opening': 'New Build Order',
      'opening_name_label': 'Build Order Name',
      'opening_name_hint': 'Ex: SCOUT RUSH - FRANKS',
      'opening_name_error': 'Enter a name',
      'civ_label': 'Civilization',
      'btn_add_villager': '+ Villager(s)',
      'btn_research': 'Research',
      'btn_age': 'Age',
      'empty_editor_steps': 'Add steps using the buttons above',
      'action_2_label': 'Action 2',
      'redistribution_subtitle': 'Redistribution',
      'resources': 'resources',
      'save_validation_error': 'Add at least one step to the sequence.',

      // Editor Dialogs
      'villager_dialog_title_add': 'Add Villager(s)',
      'villager_dialog_title_edit': 'Edit Villager Line',
      'villager_range_label': 'Villager Number or Range',
      'villager_range_hint': 'Ex: 1-6 or 7',
      'action_1_label': 'Action 1',
      'custom_action_1': 'Type your custom action 1',
      'include_action_2': 'Add Action 2 (Next)?',
      'custom_action_2': 'Type your custom action 2',
      'research_dialog_title_add': 'Select Research',
      'research_dialog_title_edit': 'Edit Research',
      'age_dialog_title_add': 'Advance Age & Redistribution',
      'age_dialog_title_edit': 'Edit Age & Redistribution',
      'target_age': 'Target Age',
      'redistribution_header': 'Villager redistribution on click:',
      'cant': 'Qty.',
      'resource': 'Resource',
      'add_resource': 'Add Resource',
      'cancel': 'Cancel',
      'save': 'Save',
      'save_age': 'Save Age',

      // Play Screen
      'playback_title': 'PLAYBACK',
      'speed_label': 'Speed',
      'current_task_title': 'CURRENT TASK',
      'villagers_count_label': 'VILLAGER(S)',
      'next_action_hint': 'Next action',
      'task_redistribution_header': 'TASK REDISTRIBUTION:',
      'next_task_prefix': 'NEXT',
      'developing': 'RESEARCHING',
      'advancing_to': 'ADVANCING TO',
      'btn_restart': 'Restart',
      'btn_stop': 'Stop',

      // Speeds
      'speed_slow': 'Slow',
      'speed_casual': 'Casual',
      'speed_normal': 'Normal',
      'speed_fast': 'Fast',

      // Actions / Preset Items (AOE2 Official English Terms)
      'Ovejas': 'Sheep',
      'Jabalí': 'Boar',
      '1er jabalí': '1st Boar',
      '2º jabalí': '2nd Boar',
      'Bayas': 'Berries',
      'Madera': 'Wood',
      'Oro': 'Gold',
      'Piedra': 'Stone',
      'Granjas': 'Farms',
      'Pesca': 'Shore Fish',
      'Construir casa': 'Build House',
      'Construir molino': 'Build Mill',
      'Campamento de madera': 'Lumber Camp',
      'Campamento de oro': 'Gold Mining Camp',
      'Campamento de piedra': 'Stone Mining Camp',
      'Construir cuartel': 'Build Barracks',
      'Construir arquería': 'Build Archery Range',
      'Construir establo': 'Build Stable',
      'Construir taller': 'Build Siege Workshop',
      'Herrería': 'Blacksmith',
      'Mercado': 'Market',
      'MODIFICABLE': 'CUSTOM',

      // Techs (AOE2 Official English Names)
      'Telar': 'Loom',
      'Collera': 'Horse Collar',
      'Hacha doble filo': 'Double-Bit Axe',
      'Explotación canteras': 'Stone Mining',
      'Minería oro': 'Gold Mining',
      'Carretilla': 'Wheelbarrow',
      'Guardia urbana': 'Town Watch',
      'Pureza de sangre': 'Bloodlines',
      'Fletching': 'Fletching',
      'Armadura': 'Forging',

      // Ages
      'FEUDAL': 'FEUDAL AGE (II)',
      'CASTILLOS': 'CASTLE AGE (III)',
      'IMPERIAL': 'IMPERIAL AGE (IV)',

      // Resources
      'COMIDA': 'FOOD',
      'MADERA': 'WOOD',
      'ORO': 'GOLD',
      'PIEDRA': 'STONE',
    },
  };
}
