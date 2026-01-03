import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/planet_state.dart';
import '../models/energy_units.dart';
import '../services/storage_service.dart';

class MotionCoreProvider with ChangeNotifier {
  PlanetState _planetState = PlanetState();
  EnergyUnits _energyUnits = EnergyUnits();
  Timer? _stepTimer;
  Timer? _saveTimer;
  int _lastStepCount = 0;
  bool _isInitialized = false;
  bool _needsEnergySave = false;
  bool _needsPlanetSave = false;
  
  // Mission ve Market sistemi
  Set<String> _completedMissions = {};
  Map<String, dynamic> _purchasedItems = {};
  double _stepMultiplier = 1.0;
  double _harvestBonus = 1.0;
  
  // Günlük adım kaydı
  String? _lastDate;
  Map<String, int> _dailySteps = {};

  PlanetState get planetState => _planetState;
  EnergyUnits get energyUnits => _energyUnits;
  Set<String> get completedMissions => _completedMissions;
  Map<String, dynamic> get purchasedItems => _purchasedItems;
  double get stepMultiplier => _stepMultiplier;
  double get harvestBonus => _harvestBonus;

  MotionCoreProvider() {
    initialize();
  }

  // Verileri yükle ve başlat (public method)
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Kaydedilmiş verileri yükle
      final energyData = await StorageService.loadEnergyData();
      final planetData = await StorageService.loadPlanetState();
      
      _energyUnits = EnergyUnits(
        steps: energyData['steps']!,
        availableEnergy: energyData['availableEnergy']!,
        totalHarvested: energyData['totalHarvested']!,
      );
      
      // Kaydedilmiş verileri yükle (Stage 1'den başla, kullanıcı manuel olarak ilerlesin)
      final savedHydro = planetData['hydrosphere']!;
      final savedAtmos = planetData['atmosphere']!;
      final savedBio = planetData['biosphere']!;
      
      // Eğer hiç veri yoksa Stage 1'den başla
      if (savedHydro == 0.0 && savedAtmos == 0.0 && savedBio == 0.0) {
        _planetState = PlanetState(
          hydrosphere: 0.0, // Stage 1: Dead Rock
          atmosphere: 0.0,
          biosphere: 0.0,
        );
      } else {
        // Kaydedilmiş verileri kullan
        _planetState = PlanetState(
          hydrosphere: savedHydro,
          atmosphere: savedAtmos,
          biosphere: savedBio,
        );
      }
      
      _lastStepCount = _energyUnits.steps;
      
      // Mission ve Market verilerini yükle
      _completedMissions = await StorageService.loadCompletedMissions();
      _purchasedItems = await StorageService.loadPurchasedItems();
      _updateActiveBoosts();
      
      // Günlük adım verilerini yükle
      _lastDate = await StorageService.loadLastDate();
      _dailySteps = await StorageService.loadDailySteps(30); // Son 30 gün
      _checkAndUpdateDailySteps();
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error loading saved data: $e');
      _isInitialized = true;
    }
  }
  
  // Aktif boost'ları güncelle
  void _updateActiveBoosts() {
    _stepMultiplier = 1.0;
    _harvestBonus = 1.0;
    
    // Step Multiplier x2
    if (_purchasedItems.containsKey('step_multiplier_2x')) {
      final expiry = _purchasedItems['step_multiplier_2x'] as int?;
      if (expiry != null && expiry > DateTime.now().millisecondsSinceEpoch) {
        _stepMultiplier = 2.0;
      }
    }
    
    // Energy Bonus +50%
    if (_purchasedItems.containsKey('energy_bonus_50')) {
      _harvestBonus = 1.5;
    }
  }
  
  // Günlük adım kaydını kontrol et ve güncelle
  void _checkAndUpdateDailySteps() {
    final now = DateTime.now();
    final todayKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    if (_lastDate != todayKey) {
      // Yeni gün başladı
      if (_lastDate != null) {
        // Önceki günün adımlarını kaydet (bugünün başlangıç adımlarından önceki günün başlangıç adımlarını çıkar)
        final yesterdayStartSteps = _dailySteps[_lastDate!] ?? 0;
        final yesterdayEndSteps = _energyUnits.steps;
        final yesterdayTotalSteps = yesterdayEndSteps - yesterdayStartSteps;
        if (yesterdayTotalSteps > 0) {
          StorageService.saveDailySteps(_lastDate!, yesterdayTotalSteps);
          _dailySteps[_lastDate!] = yesterdayTotalSteps;
        }
      }
      
      // Bugünün başlangıç adım sayısını kaydet
      _dailySteps[todayKey] = _energyUnits.steps;
      StorageService.saveLastDate(todayKey);
      _lastDate = todayKey;
    }
    // Aynı gün, sadece güncelleme yapılır (kayıt updateSteps'te yapılacak)
  }
  
  // Bugünün adımlarını güncelle
  void _updateTodaySteps() {
    final now = DateTime.now();
    final todayKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    // Bugünün başlangıç adımlarını al
    final todayStartSteps = _dailySteps[todayKey] ?? _energyUnits.steps;
    
    // Bugünün toplam adımlarını hesapla
    final todayTotalSteps = _energyUnits.steps - todayStartSteps;
    
    // Kaydet
    if (todayTotalSteps > 0) {
      StorageService.saveDailySteps(todayKey, todayTotalSteps);
      _dailySteps[todayKey] = todayTotalSteps;
    }
  }

  // Sensor service'den adım güncellemesi için
  void setStepTracking(bool enabled) {
    if (enabled && _stepTimer == null) {
      // Demo modu: Her 3 saniyede bir küçük artış
      _stepTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        // Gerçek sensor'dan geliyorsa bu timer gerekmez
        // Sadece demo için
      });
    } else if (!enabled && _stepTimer != null) {
      _stepTimer?.cancel();
      _stepTimer = null;
    }
  }

  // Adımları güncelle (sensor'dan veya manuel)
  void updateSteps(int steps) {
    if (steps > _lastStepCount) {
      final newSteps = steps - _lastStepCount;
      _lastStepCount = steps;
      
      // Multiplier uygula
      final energyGain = (newSteps * _stepMultiplier).toInt();
      
      // Her adım = 1 enerji birimi (multiplier ile)
      _energyUnits = _energyUnits.copyWith(
        steps: steps,
        availableEnergy: _energyUnits.availableEnergy + energyGain,
      );
      
      // Verileri kaydet (debounced)
      _saveEnergyData();
      
      // Günlük adım kaydını güncelle (bugünün adımlarını kaydet)
      _updateTodaySteps();
      
      // Sadece önemli değişikliklerde notify (her 50 adımda bir veya 20+ adım artış)
      if (newSteps >= 20 || steps % 50 == 0) {
        notifyListeners();
      }
    }
  }
  
  // Enerji verilerini kaydet (debounced - 1 saniye sonra)
  void _saveEnergyData() {
    _needsEnergySave = true;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () {
      if (_needsEnergySave) {
        StorageService.saveEnergyData(
          steps: _energyUnits.steps,
          availableEnergy: _energyUnits.availableEnergy,
          totalHarvested: _energyUnits.totalHarvested,
        );
        _needsEnergySave = false;
      }
    });
  }
  
  // Gezegen verilerini kaydet (debounced - 1 saniye sonra)
  void _savePlanetData() {
    _needsPlanetSave = true;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () {
      if (_needsPlanetSave) {
        StorageService.savePlanetState(
          hydrosphere: _planetState.hydrosphere,
          atmosphere: _planetState.atmosphere,
          biosphere: _planetState.biosphere,
        );
        _needsPlanetSave = false;
      }
    });
  }
  
  // Hemen kaydet (harvest ve commit gibi önemli işlemler için)
  void _saveEnergyDataImmediate() {
    _saveTimer?.cancel();
    _needsEnergySave = false;
    StorageService.saveEnergyData(
      steps: _energyUnits.steps,
      availableEnergy: _energyUnits.availableEnergy,
      totalHarvested: _energyUnits.totalHarvested,
    );
  }
  
  void _savePlanetDataImmediate() {
    _saveTimer?.cancel();
    _needsPlanetSave = false;
    StorageService.savePlanetState(
      hydrosphere: _planetState.hydrosphere,
      atmosphere: _planetState.atmosphere,
      biosphere: _planetState.biosphere,
    );
  }

  // Enerjiyi topla (harvest)
  void harvestEnergy() {
    if (_energyUnits.availableEnergy > 0) {
      // Harvest bonus uygula
      final harvested = (_energyUnits.availableEnergy * _harvestBonus).toInt();
      
      _energyUnits = _energyUnits.copyWith(
        totalHarvested: _energyUnits.totalHarvested + harvested,
        availableEnergy: 0,
      );
      _saveEnergyDataImmediate(); // Önemli işlem, hemen kaydet
      notifyListeners();
    }
  }
  
  // Mission ödülü ver
  Future<bool> claimMissionReward(String missionId, int reward) async {
    if (_completedMissions.contains(missionId)) {
      return false; // Zaten tamamlanmış
    }
    
    // Ödülü ver
    _energyUnits = _energyUnits.copyWith(
      totalHarvested: _energyUnits.totalHarvested + reward,
    );
    
    // Mission'ı tamamlanmış olarak işaretle
    _completedMissions.add(missionId);
    await StorageService.saveCompletedMissions(_completedMissions);
    
    _saveEnergyDataImmediate();
    notifyListeners();
    return true;
  }
  
  // Market item satın al
  Future<bool> purchaseMarketItem(String itemId, int price, {int? durationHours}) async {
    if (_energyUnits.totalHarvested < price) {
      return false; // Yetersiz enerji
    }
    
    // Enerjiyi düş
    _energyUnits = _energyUnits.copyWith(
      totalHarvested: _energyUnits.totalHarvested - price,
    );
    
    // Item'ı satın alınmış olarak işaretle
    if (durationHours != null) {
      // Süreli item (örn: 24 saat)
      final expiry = DateTime.now().add(Duration(hours: durationHours)).millisecondsSinceEpoch;
      _purchasedItems[itemId] = expiry;
    } else {
      // Kalıcı item
      _purchasedItems[itemId] = true;
    }
    
    await StorageService.savePurchasedItems(_purchasedItems);
    _updateActiveBoosts();
    _saveEnergyDataImmediate();
    notifyListeners();
    return true;
  }
  
  // Günlük adım verilerini al
  Future<Map<String, int>> getDailySteps(int days) async {
    final now = DateTime.now();
    final Map<String, int> result = {};
    
    // Storage'dan güncel verileri yükle
    final storedData = await StorageService.loadDailySteps(days);
    
    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      result[dateKey] = storedData[dateKey] ?? 0;
    }
    
    return result;
  }
  
  // Haftalık adım verilerini al
  Future<Map<String, int>> getWeeklySteps(int weeks) async {
    final now = DateTime.now();
    final Map<String, int> result = {};
    
    // Storage'dan güncel verileri yükle (4 hafta = 28 gün)
    final storedData = await StorageService.loadDailySteps(weeks * 7);
    
    for (int i = 0; i < weeks; i++) {
      final weekStart = now.subtract(Duration(days: i * 7));
      final weekKey = 'Week ${weeks - i}';
      
      int weekTotal = 0;
      for (int j = 0; j < 7; j++) {
        final date = weekStart.subtract(Duration(days: j));
        final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        weekTotal += storedData[dateKey] ?? 0;
      }
      
      result[weekKey] = weekTotal;
    }
    
    return result;
  }

  // Gezegen durumunu güncelle (terraforming)
  void updatePlanetState({
    double? hydrosphere,
    double? atmosphere,
    double? biosphere,
  }) {
    _planetState = _planetState.copyWith(
      hydrosphere: hydrosphere,
      atmosphere: atmosphere,
      biosphere: biosphere,
    );
    _savePlanetData();
    notifyListeners();
  }

  // Enerji harca ve gezegeni güncelle (COMMIT PROCESS)
  bool commitTerraforming({
    required double hydrosphere,
    required double atmosphere,
    required double biosphere,
  }) {
    final current = _planetState;
    
    // Değişiklik miktarını hesapla
    final hydroDiff = (hydrosphere - current.hydrosphere).abs();
    final atmosDiff = (atmosphere - current.atmosphere).abs();
    final bioDiff = (biosphere - current.biosphere).abs();
    
    // Her %1 değişiklik = 100 enerji birimi
    final cost = ((hydroDiff + atmosDiff + bioDiff) * 100).toInt();
    
    if (_energyUnits.totalHarvested < cost) {
      return false; // Yetersiz enerji
    }

    _energyUnits = _energyUnits.copyWith(
      totalHarvested: _energyUnits.totalHarvested - cost,
    );
    _saveEnergyDataImmediate(); // Önemli işlem, hemen kaydet

    _planetState = _planetState.copyWith(
      hydrosphere: hydrosphere,
      atmosphere: atmosphere,
      biosphere: biosphere,
    );
    _savePlanetDataImmediate(); // Önemli işlem, hemen kaydet
    notifyListeners();

    return true;
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _saveTimer?.cancel();
    // Son kayıtları yap
    if (_needsEnergySave) {
      StorageService.saveEnergyData(
        steps: _energyUnits.steps,
        availableEnergy: _energyUnits.availableEnergy,
        totalHarvested: _energyUnits.totalHarvested,
      );
    }
    if (_needsPlanetSave) {
      StorageService.savePlanetState(
        hydrosphere: _planetState.hydrosphere,
        atmosphere: _planetState.atmosphere,
        biosphere: _planetState.biosphere,
      );
    }
    super.dispose();
  }
}
