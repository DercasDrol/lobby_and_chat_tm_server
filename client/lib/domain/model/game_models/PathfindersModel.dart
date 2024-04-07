class PathfindersModel {
  final int venus;
  final int earth;
  final int mars;
  final int jovian;
  final int moon;

  PathfindersModel({
    required this.venus,
    required this.earth,
    required this.mars,
    required this.jovian,
    required this.moon,
  });

  static PathfindersModel fromJson(Map<String, dynamic> json) {
    return PathfindersModel(
      venus: json['venus'] as int,
      earth: json['earth'] as int,
      mars: json['mars'] as int,
      jovian: json['jovian'] as int,
      moon: json['moon'] as int,
    );
  }
}
