// To parse this JSON data, do
//
//     final squintScanResponseModel = squintScanResponseModelFromJson(jsonString);

import 'dart:convert';

SquintScanResponseModel squintScanResponseModelFromJson(String str) => SquintScanResponseModel.fromJson(json.decode(str));

String squintScanResponseModelToJson(SquintScanResponseModel data) => json.encode(data.toJson());

class SquintScanResponseModel {
  bool? success;
  String? imageId;
  bool? qualityPassed;
  QualityScores? qualityScores;
  Result? result;
  String? disclaimer;

  SquintScanResponseModel({
    this.success,
    this.imageId,
    this.qualityPassed,
    this.qualityScores,
    this.result,
    this.disclaimer,
  });

  factory SquintScanResponseModel.fromJson(Map<String, dynamic> json) => SquintScanResponseModel(
    success: json["success"],
    imageId: json["image_id"],
    qualityPassed: json["quality_passed"],
    qualityScores: json["quality_scores"] == null ? null : QualityScores.fromJson(json["quality_scores"]),
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
    disclaimer: json["disclaimer"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "image_id": imageId,
    "quality_passed": qualityPassed,
    "quality_scores": qualityScores?.toJson(),
    "result": result?.toJson(),
    "disclaimer": disclaimer,
  };
}

class QualityScores {
  double? brightness;
  double? contrast;
  double? sharpness;
  double? faceConfidence;
  double? faceCount;

  QualityScores({
    this.brightness,
    this.contrast,
    this.sharpness,
    this.faceConfidence,
    this.faceCount,
  });

  factory QualityScores.fromJson(Map<String, dynamic> json) => QualityScores(
    brightness: (json["brightness"] as num).toDouble(),
    contrast: (json["contrast"] as num).toDouble(),
    sharpness: (json["sharpness"] as num).toDouble(),
    faceConfidence: (json["face_confidence"] as num).toDouble(),
    faceCount: (json["face_count"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "brightness": brightness,
    "contrast": contrast,
    "sharpness": sharpness,
    "face_confidence": faceConfidence,
    "face_count": faceCount,
  };
}

class Result {
  int? prediction;
  String? label;
  double? confidence;
  Probabilities? probabilities;
  String? screeningResult;
  String? recommendation;
  Map<String, double>? features;
  List<String>? notes;

  Result({
    this.prediction,
    this.label,
    this.confidence,
    this.probabilities,
    this.screeningResult,
    this.recommendation,
    this.features,
    this.notes,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    prediction: (json["prediction"] as num ).toInt(),
    label: json["label"],
    confidence: (json["confidence"] as num).toDouble(),
    probabilities: json["probabilities"] == null ? null : Probabilities.fromJson(json["probabilities"]),
    screeningResult: json["screening_result"],
    recommendation: json["recommendation"],
    features: Map.from(json["features"]!).map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
    notes: json["notes"] == null ? [] : List<String>.from(json["notes"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "prediction": prediction,
    "label": label,
    "confidence": confidence,
    "probabilities": probabilities?.toJson(),
    "screening_result": screeningResult,
    "recommendation": recommendation,
    "features": Map.from(features!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x)),
  };
}

class Probabilities {
  double? normal;
  double? squint;

  Probabilities({
    this.normal,
    this.squint,
  });

  factory Probabilities.fromJson(Map<String, dynamic> json) => Probabilities(
    normal: (json["normal"] as num ).toDouble(),
    squint: (json["squint"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "normal": normal,
    "squint": squint,
  };
}
