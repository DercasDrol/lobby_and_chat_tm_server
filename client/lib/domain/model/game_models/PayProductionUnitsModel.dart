import 'package:mars_flutter/domain/model/Units.dart';

class PayProductionModel {
  final int cost;
  final Units units;

  PayProductionModel({
    required this.cost,
    required this.units,
  });

  static fromJson(Map<String, dynamic> json) {
    return PayProductionModel(
      cost: json['cost'] as int,
      units: Units.fromJson(json: json['units'] as Map<String, dynamic>),
    );
  }
}
