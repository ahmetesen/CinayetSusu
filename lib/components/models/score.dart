import 'package:json_annotation/json_annotation.dart';
part 'score.g.dart';

@JsonSerializable(includeIfNull: false, anyMap: true)
class Score{
  String deviceId;
  String displayName;
  String scoreId;
  int score;


  Score({this.deviceId,this.scoreId,this.score});

    factory Score.fromJson(Map<dynamic, dynamic> json) {
    return _$ScoreFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ScoreToJson(this);
}