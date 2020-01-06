// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) {
  return User(
      deviceId: json['deviceId'] as String,
      topScore: json['topScore'] as int,
      displayName: json['displayName'] as String,
      lastPlayDate: json['lastPlayDate'] == null
          ? null
          : DateTime.parse(json['lastPlayDate'] as String),
      createDate: json['createDate'] == null
          ? null
          : DateTime.parse(json['createDate'] as String),
      isIos: json['isIos'] as bool,
      deviceModel: json['deviceModel'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('deviceId', instance.deviceId);
  writeNotNull('topScore', instance.topScore);
  writeNotNull('displayName', instance.displayName);
  writeNotNull('lastPlayDate', instance.lastPlayDate?.toIso8601String());
  writeNotNull('createDate', instance.createDate?.toIso8601String());
  writeNotNull('isIos', instance.isIos);
  writeNotNull('deviceModel', instance.deviceModel);
  return val;
}
