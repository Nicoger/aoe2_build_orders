import 'language_service.dart';
import '../models/build_step.dart';

class CivBonuses {
  static final List<Map<String, String>> _civsEs = [
    {'id': 'generic', 'name': 'Genérica / Cualquiera'},
    {'id': 'armenians', 'name': 'Armenios'},
    {'id': 'aztecs', 'name': 'Aztecas'},
    {'id': 'bengalis', 'name': 'Bengalíes'},
    {'id': 'berbers', 'name': 'Berberiscos / Bereberes'},
    {'id': 'bohemians', 'name': 'Bohemios'},
    {'id': 'britons', 'name': 'Britanos'},
    {'id': 'bulgarians', 'name': 'Búlgaros'},
    {'id': 'burgundians', 'name': 'Borgoñones'},
    {'id': 'burmese', 'name': 'Birmanos'},
    {'id': 'byzantines', 'name': 'Bizantinos'},
    {'id': 'celts', 'name': 'Celtas'},
    {'id': 'chinese', 'name': 'Chinos'},
    {'id': 'cumans', 'name': 'Cumanos'},
    {'id': 'danes', 'name': 'Daneses'},
    {'id': 'dravidians', 'name': 'Drávidas / Dravídicos'},
    {'id': 'ethiopians', 'name': 'Etíopes'},
    {'id': 'franks', 'name': 'Francos'},
    {'id': 'georgians', 'name': 'Georgianos'},
    {'id': 'goths', 'name': 'Godos'},
    {'id': 'gurjaras', 'name': 'Gurjaras'},
    {'id': 'hindustanis', 'name': 'Hindustaníes'},
    {'id': 'huns', 'name': 'Hunos'},
    {'id': 'incas', 'name': 'Incas'},
    {'id': 'italians', 'name': 'Italianos'},
    {'id': 'japanese', 'name': 'Japoneses'},
    {'id': 'jurchens', 'name': 'Yurchen / Jurchens'},
    {'id': 'khitans', 'name': 'Kitán / Khitans'},
    {'id': 'khmer', 'name': 'Jemeres / Khmer'},
    {'id': 'koreans', 'name': 'Coreanos'},
    {'id': 'lithuanians', 'name': 'Lituanos'},
    {'id': 'magyars', 'name': 'Magiares'},
    {'id': 'malay', 'name': 'Malayos'},
    {'id': 'malians', 'name': 'Malíes'},
    {'id': 'mapuches', 'name': 'Mapuches'},
    {'id': 'mayans', 'name': 'Mayas'},
    {'id': 'mongols', 'name': 'Mongoles'},
    {'id': 'muiscas', 'name': 'Muiscas'},
    {'id': 'persians', 'name': 'Persas'},
    {'id': 'poles', 'name': 'Polacos'},
    {'id': 'portuguese', 'name': 'Portugueses'},
    {'id': 'romans', 'name': 'Romanos'},
    {'id': 'saracens', 'name': 'Sarracenos'},
    {'id': 'saxons', 'name': 'Sajones'},
    {'id': 'shu', 'name': 'Shu'},
    {'id': 'sicilians', 'name': 'Sicilianos'},
    {'id': 'slavs', 'name': 'Eslavos'},
    {'id': 'spanish', 'name': 'Españoles'},
    {'id': 'tatars', 'name': 'Tártaros'},
    {'id': 'teutons', 'name': 'Teutones'},
    {'id': 'tupis', 'name': 'Tupíes'},
    {'id': 'turks', 'name': 'Turcos'},
    {'id': 'varangians', 'name': 'Varegos'},
    {'id': 'vietnamese', 'name': 'Vietnamitas'},
    {'id': 'vikings', 'name': 'Vikingos'},
    {'id': 'wei', 'name': 'Wei'},
    {'id': 'wu', 'name': 'Wu'},
  ];

  static final List<Map<String, String>> _civsEn = [
    {'id': 'generic', 'name': 'Generic / Any'},
    {'id': 'armenians', 'name': 'Armenians'},
    {'id': 'aztecs', 'name': 'Aztecs'},
    {'id': 'bengalis', 'name': 'Bengalis'},
    {'id': 'berbers', 'name': 'Berbers'},
    {'id': 'bohemians', 'name': 'Bohemians'},
    {'id': 'britons', 'name': 'Britons'},
    {'id': 'bulgarians', 'name': 'Bulgarians'},
    {'id': 'burgundians', 'name': 'Burgundians'},
    {'id': 'burmese', 'name': 'Burmese'},
    {'id': 'byzantines', 'name': 'Byzantines'},
    {'id': 'celts', 'name': 'Celts'},
    {'id': 'chinese', 'name': 'Chinese'},
    {'id': 'cumans', 'name': 'Cumans'},
    {'id': 'danes', 'name': 'Danes'},
    {'id': 'dravidians', 'name': 'Dravidians'},
    {'id': 'ethiopians', 'name': 'Ethiopians'},
    {'id': 'franks', 'name': 'Franks'},
    {'id': 'georgians', 'name': 'Georgians'},
    {'id': 'goths', 'name': 'Goths'},
    {'id': 'gurjaras', 'name': 'Gurjaras'},
    {'id': 'hindustanis', 'name': 'Hindustanis'},
    {'id': 'huns', 'name': 'Huns'},
    {'id': 'incas', 'name': 'Incas'},
    {'id': 'italians', 'name': 'Italians'},
    {'id': 'japanese', 'name': 'Japanese'},
    {'id': 'jurchens', 'name': 'Jurchens'},
    {'id': 'khitans', 'name': 'Khitans'},
    {'id': 'khmer', 'name': 'Khmer'},
    {'id': 'koreans', 'name': 'Koreans'},
    {'id': 'lithuanians', 'name': 'Lithuanians'},
    {'id': 'magyars', 'name': 'Magyars'},
    {'id': 'malay', 'name': 'Malay'},
    {'id': 'malians', 'name': 'Malians'},
    {'id': 'mapuches', 'name': 'Mapuches'},
    {'id': 'mayans', 'name': 'Mayans'},
    {'id': 'mongols', 'name': 'Mongols'},
    {'id': 'muiscas', 'name': 'Muiscas'},
    {'id': 'persians', 'name': 'Persians'},
    {'id': 'poles', 'name': 'Poles'},
    {'id': 'portuguese', 'name': 'Portuguese'},
    {'id': 'romans', 'name': 'Romans'},
    {'id': 'saracens', 'name': 'Saracens'},
    {'id': 'saxons', 'name': 'Saxons'},
    {'id': 'shu', 'name': 'Shu'},
    {'id': 'sicilians', 'name': 'Sicilians'},
    {'id': 'slavs', 'name': 'Slavs'},
    {'id': 'spanish', 'name': 'Spanish'},
    {'id': 'tatars', 'name': 'Tatars'},
    {'id': 'teutons', 'name': 'Teutones'},
    {'id': 'tupis', 'name': 'Tupis'},
    {'id': 'turks', 'name': 'Turks'},
    {'id': 'varangians', 'name': 'Varangians'},
    {'id': 'vietnamese', 'name': 'Vietnamese'},
    {'id': 'vikings', 'name': 'Vikings'},
    {'id': 'wei', 'name': 'Wei'},
    {'id': 'wu', 'name': 'Wu'},
  ];

  static List<Map<String, String>> get allCivs {
    return LanguageService().currentLanguage == 'en' ? _civsEn : _civsEs;
  }

  static double getGameSpeedMultiplier(String speedMode) {
    if (speedMode == 'Lenta' || speedMode == 'Slow') return 1.0;
    if (speedMode == 'Casual') return 1.5;
    if (speedMode == 'Normal') return 1.7;
    if (speedMode == 'Rápida' || speedMode == 'Fast') return 2.0;
    return 1.7;
  }

  /// CALCULA CUÁNTOS ALDEANOS SE CREAN EN BASE AL RANGO (ej. "1-6" -> 6, "4-7" -> 4)
  static int parseVillagerCount(String? villagerRange) {
    if (villagerRange == null || villagerRange.trim().isEmpty) {
      return 1;
    }

    final clean = villagerRange.trim();

    if (clean.contains('-')) {
      final parts = clean.split('-');
      if (parts.length == 2) {
        final start = int.tryParse(parts[0].trim());
        final end = int.tryParse(parts[1].trim());
        if (start != null && end != null) {
          return (end - start).abs() + 1;
        }
      }
    }

    return 1;
  }

  /// CALCULA LA DURACIÓN EN SEGUNDOS APLICANDO BONUS DE CIVILIZACIÓN
  static double getAdjustedStepDuration(
      BuildStep step, String civId, String currentAge) {
    double baseDuration = step.durationInGameSecs;

    // Si el paso es de creación de aldeanos, multiplicamos la duración base (25s)
    // por la cantidad total de aldeanos calculada desde el rango (ej. "1-6" = 6 aldeanos = 150s)
    if (step.type == StepType.villager) {
      int villagerCount = parseVillagerCount(step.villagerRange);
      baseDuration = baseDuration * villagerCount;
    }

    // 1. BONUS PERSAS (Creación de aldeanos)
    if (civId == 'persians' && step.type == StepType.villager) {
      if (currentAge == 'FEUDAL') {
        return baseDuration / 1.10; // +10% más rápido
      } else if (currentAge == 'CASTILLOS' || currentAge == 'CASTLE') {
        return baseDuration / 1.15; // +15% más rápido
      } else if (currentAge == 'IMPERIAL') {
        return baseDuration / 1.20; // +20% más rápido
      }
    }

    // 2. BONUS MALAYOS (Avance de edad +66% más rápido)
    if (civId == 'malay' && step.type == StepType.ageUp) {
      return baseDuration / 1.66;
    }

    // 3. BONUS CHINOS (Tecnologías / Desarrollos investigados más rápido)
    if (civId == 'chinese' && step.type == StepType.research) {
      if (currentAge == 'FEUDAL') return baseDuration * 0.90; // 10% más rápido
      if (currentAge == 'CASTILLOS' || currentAge == 'CASTLE')
        return baseDuration * 0.85; // 15% más rápido
      if (currentAge == 'IMPERIAL')
        return baseDuration * 0.80; // 20% más rápido
    }

    return baseDuration;
  }
}
