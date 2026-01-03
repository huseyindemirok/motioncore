class EnergyUnits {
  final int steps;
  final int availableEnergy; // Kullanılabilir enerji (harvest edilmemiş)
  final int totalHarvested; // Toplam toplanan enerji

  EnergyUnits({
    this.steps = 0,
    this.availableEnergy = 0,
    this.totalHarvested = 0,
  });

  EnergyUnits copyWith({
    int? steps,
    int? availableEnergy,
    int? totalHarvested,
  }) {
    return EnergyUnits(
      steps: steps ?? this.steps,
      availableEnergy: availableEnergy ?? this.availableEnergy,
      totalHarvested: totalHarvested ?? this.totalHarvested,
    );
  }

  // Adımları enerji birimine dönüştür (1 adım = 1 enerji birimi)
  int stepsToEnergy(int stepCount) {
    return stepCount;
  }

  // Enerjiyi topla (harvest)
  EnergyUnits harvest() {
    final newHarvested = totalHarvested + availableEnergy;
    return copyWith(
      availableEnergy: 0,
      totalHarvested: newHarvested,
    );
  }
}

