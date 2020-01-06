// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Score _$ScoreFromJson(Map json) {
  return Score(
      deviceId: json['deviceId'] as String,
      scoreId: json['scoreId'] as String,
      score: json['score'] as int)
    ..displayName = json['displayName'] as String;
}

Map<String, dynamic> _$ScoreToJson(Score instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('deviceId', instance.deviceId);
  writeNotNull('displayName', instance.displayName);
  writeNotNull('scoreId', instance.scoreId);
  writeNotNull('score', instance.score);
  return val;
}
