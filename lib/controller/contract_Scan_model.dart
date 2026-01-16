// To parse this JSON data, do
//
//     final cataractScanResponseModel = cataractScanResponseModelFromJson(jsonString);

import 'dart:convert';

CataractScanResponseModel cataractScanResponseModelFromJson(String str) => CataractScanResponseModel.fromJson(json.decode(str));

String cataractScanResponseModelToJson(CataractScanResponseModel data) => json.encode(data.toJson());

class CataractScanResponseModel {
  bool? success;
  String? imageId;
  bool? qualityPassed;
  String? error;
  Scores? qualityScores;
  QualityCheck? qualityCheck;

  CataractScanResponseModel({
    this.success,
    this.imageId,
    this.qualityPassed,
    this.error,
    this.qualityScores,
    this.qualityCheck,
  });

  factory CataractScanResponseModel.fromJson(Map<String, dynamic> json) => CataractScanResponseModel(
    success: json["success"],
    imageId: json["image_id"],
    qualityPassed: json["quality_passed"],
    error: json["error"],
    qualityScores: json["quality_scores"] == null ? null : Scores.fromJson(json["quality_scores"]),
    qualityCheck: json["quality_check"] == null ? null : QualityCheck.fromJson(json["quality_check"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "image_id": imageId,
    "quality_passed": qualityPassed,
    "error": error,
    "quality_scores": qualityScores?.toJson(),
    "quality_check": qualityCheck?.toJson(),
  };
}

class QualityCheck {
  bool? passed;
  Scores? scores;
  List<String>? issues;

  QualityCheck({
    this.passed,
    this.scores,
    this.issues,
  });

  factory QualityCheck.fromJson(Map<String, dynamic> json) => QualityCheck(
    passed: json["passed"],
    scores: json["scores"] == null ? null : Scores.fromJson(json["scores"]),
    issues: json["issues"] == null ? [] : List<String>.from(json["issues"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "passed": passed,
    "scores": scores?.toJson(),
    "issues": issues == null ? [] : List<dynamic>.from(issues!.map((x) => x)),
  };
}

class Scores {
  double? brightness;
  double? contrast;

  Scores({
    this.brightness,
    this.contrast,
  });

  factory Scores.fromJson(Map<String, dynamic> json) => Scores(
    brightness: json["brightness"]?.toDouble(),
    contrast: json["contrast"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "brightness": brightness,
    "contrast": contrast,
  };
}
