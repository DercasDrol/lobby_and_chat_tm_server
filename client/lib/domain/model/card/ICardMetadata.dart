import 'package:mars_flutter/domain/model/card/render/CardComponents.dart';
import 'package:mars_flutter/domain/model/card/render/ICardRenderDescription.dart';
import 'package:mars_flutter/domain/model/card/render/ICardRenderVictoryPoints.dart';

class ICardMetadata {
  String? cardNumber;
  ICardRenderDescription? description;
  CardComponent? renderData;
  ICardRenderVictoryPoints? victoryPoints;
  ICardMetadata({
    this.cardNumber,
    this.description,
    this.renderData,
    this.victoryPoints,
  });
  factory ICardMetadata.fromJson(Map<String, dynamic> json) {
    return ICardMetadata(
      cardNumber: json['cardNumber'],
      description: json['description'] == null
          ? null
          : json['description'].runtimeType == String
              ? ICardRenderDescription(
                  json['description'], DescriptionAlign.CENTER)
              : ICardRenderDescription.fromJson(json['description']),
      renderData: json['renderData'] == null
          ? null
          : CardComponent.fromJson(json['renderData']),
      victoryPoints: json['victoryPoints'] == null
          ? null
          : json['victoryPoints'].runtimeType == int
              ? ICardRenderStaticVictoryPoints(points: json['victoryPoints'])
              : ICardRenderDynamicVictoryPoints.fromJson(json['victoryPoints']),
    );
  }
}
