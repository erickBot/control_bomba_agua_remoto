// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  int? power;
  double? current;
  double? frecuencia;
  double? hours;
  String? code;

  DataModel({
    this.power,
    this.current,
    this.frecuencia,
    this.hours,
    this.code,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        power: json["power"] is int ? json["power"].toDouble() : json["power"],
        current: json["current"] is int
            ? json["current"].toDouble()
            : json["current"],
        frecuencia: json["frecuencia"] is int
            ? json["frecuencia"].toDouble()
            : json["frecuencia"],
        hours: json["hours"] is int ? json["hours"].toDouble() : json["hours"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "power": power,
        "current": current,
        "frecuencia": frecuencia,
        "hours": hours,
        "code": code,
      };
}
