import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable(includeIfNull: false, anyMap: true)
class User{
  String deviceId;
  int topScore;
  String displayName;
  DateTime lastPlayDate;
  DateTime createDate;
  bool isIos;
  String deviceModel;

  User({this.deviceId,this.topScore,this.displayName,this.lastPlayDate,this.createDate,this.isIos,this.deviceModel});

    factory User.fromJson(Map<dynamic, dynamic> json) {
    return _$UserFromJson(json);
  }

  // _$UserToJson is generated and available in user.g.dart
  Map<String, dynamic> toJson() => _$UserToJson(this);
}