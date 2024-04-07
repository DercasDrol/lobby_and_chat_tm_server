class Units {
  final int? megacredits;
  final int? steel;
  final int? titanium;
  final int? plants;
  final int? energy;
  final int? heat;
  Units({
    this.megacredits,
    this.steel,
    this.titanium,
    this.plants,
    this.energy,
    this.heat,
  });
  factory Units.fromJson({required Map<String, dynamic> json}) {
    return Units(
      megacredits: json['megacredits'] as int?,
      steel: json['steel'] as int?,
      titanium: json['titanium'] as int?,
      plants: json['plants'] as int?,
      energy: json['energy'] as int?,
      heat: json['heat'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'megacredits': megacredits,
      'steel': steel,
      'titanium': titanium,
      'plants': plants,
      'energy': energy,
      'heat': heat,
    };
  }
}
