import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keySteps = 'motioncore_steps';
  static const String _keyAvailableEnergy = 'motioncore_available_energy';
  static const String _keyTotalHarvested = 'motioncore_total_harvested';
  static const String _keyHydrosphere = 'motioncore_hydrosphere';
  static const String _keyAtmosphere = 'motioncore_atmosphere';
  static const String _keyBiosphere = 'motioncore_biosphere';
  static const String _keyCompletedMissions = 'motioncore_completed_missions';
  static const String _keyPurchasedItems = 'motioncore_purchased_items';
  static const String _keyDailySteps = 'motioncore_daily_steps';
  static const String _keyLastDate = 'motioncore_last_date';

  // Adım ve enerji verilerini kaydet
  static Future<void> saveEnergyData({
    required int steps,
    required int availableEnergy,
    required int totalHarvested,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keySteps, steps);
    await prefs.setInt(_keyAvailableEnergy, availableEnergy);
    await prefs.setInt(_keyTotalHarvested, totalHarvested);
  }

  // Adım ve enerji verilerini yükle
  static Future<Map<String, int>> loadEnergyData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'steps': prefs.getInt(_keySteps) ?? 0,
      'availableEnergy': prefs.getInt(_keyAvailableEnergy) ?? 0,
      'totalHarvested': prefs.getInt(_keyTotalHarvested) ?? 0,
    };
  }

  // Gezegen durumunu kaydet
  static Future<void> savePlanetState({
    required double hydrosphere,
    required double atmosphere,
    required double biosphere,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyHydrosphere, hydrosphere);
    await prefs.setDouble(_keyAtmosphere, atmosphere);
    await prefs.setDouble(_keyBiosphere, biosphere);
  }

  // Gezegen durumunu yükle
  static Future<Map<String, double>> loadPlanetState() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hydrosphere': prefs.getDouble(_keyHydrosphere) ?? 0.0,
      'atmosphere': prefs.getDouble(_keyAtmosphere) ?? 0.0,
      'biosphere': prefs.getDouble(_keyBiosphere) ?? 0.0,
    };
  }

  // Mission completion durumunu kaydet
  static Future<void> saveCompletedMissions(Set<String> missionIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCompletedMissions, missionIds.toList());
  }

  // Mission completion durumunu yükle
  static Future<Set<String>> loadCompletedMissions() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyCompletedMissions) ?? [];
    return list.toSet();
  }

  // Satın alınan item'ları kaydet
  static Future<void> savePurchasedItems(Map<String, dynamic> items) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = items.keys.toList();
    await prefs.setStringList('${_keyPurchasedItems}_keys', keys);
    for (final key in keys) {
      final value = items[key];
      if (value is int) {
        await prefs.setInt('${_keyPurchasedItems}_$key', value);
      } else if (value is String) {
        await prefs.setString('${_keyPurchasedItems}_$key', value);
      } else if (value is bool) {
        await prefs.setBool('${_keyPurchasedItems}_$key', value);
      }
    }
  }

  // Satın alınan item'ları yükle
  static Future<Map<String, dynamic>> loadPurchasedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getStringList('${_keyPurchasedItems}_keys') ?? [];
    final Map<String, dynamic> items = {};
    for (final key in keys) {
      if (prefs.containsKey('${_keyPurchasedItems}_$key')) {
        final value = prefs.get('${_keyPurchasedItems}_$key');
        if (value != null) {
          items[key] = value;
        }
      }
    }
    return items;
  }

  // Günlük adım verilerini kaydet
  static Future<void> saveDailySteps(String date, int steps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_keyDailySteps}_$date', steps);
  }

  // Günlük adım verilerini yükle
  static Future<Map<String, int>> loadDailySteps(int days) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, int> dailyData = {};
    final now = DateTime.now();
    
    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final steps = prefs.getInt('${_keyDailySteps}_$dateKey') ?? 0;
      dailyData[dateKey] = steps;
    }
    
    return dailyData;
  }

  // Son tarihi kaydet
  static Future<void> saveLastDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastDate, date);
  }

  // Son tarihi yükle
  static Future<String?> loadLastDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastDate);
  }
}

