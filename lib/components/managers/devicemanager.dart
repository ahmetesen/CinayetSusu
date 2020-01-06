import 'dart:io' show Platform;
import 'package:cinayetsusu/components/managers/fbmanager.dart';
import 'package:cinayetsusu/components/models/user.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceManager{
  static DeviceManager _instance = DeviceManager._internal();

  factory DeviceManager() {
    return _instance ??= new DeviceManager._internal();
  }
  DeviceManager._internal();
  User currentUser = new User(isIos: Platform.isIOS);
  final _storage = new FlutterSecureStorage();
  bool muted = false;

  Future initializeUserAndDeviceInfo() async {
    String mute = await _storage.read(key: 'muted');
    muted = (mute!=null);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isIOS){
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      currentUser.deviceModel = iosInfo.name+iosInfo.utsname.machine;
    }
    else if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      currentUser.deviceModel = androidInfo.model;
    }
    else
      currentUser.deviceModel = 'unknown';

    if(currentUser.deviceId!=null)
      return;
    String value = await _storage.read(key: 'deviceId');
    if(value == null){
      try{
        currentUser.deviceId = await FBManager().createUser(user: currentUser);
        await _storage.write(key: 'deviceId',value: currentUser.deviceId);
      }
      catch(err){
        throw err;
      }
    }
    else{
        currentUser.deviceId = value;
        currentUser.displayName = await _storage.read(key: 'displayName');
    }
  }     

  Future updateUsername({String displayName}) async {
    var user = new User(deviceId: currentUser.deviceId,displayName: displayName);
    try{
      await FBManager().updateUser(user);
      await _storage.write(key: 'displayName',value: displayName);
    }
    catch(err){
      //TODO:log errors
    }
  }

  Future deleteSavedUserOnDevice() async {
    await _storage.deleteAll();
  }

  Future toggleVolume()async{
    //TODO: Do volume business
    if(muted){
      await _storage.delete(key:'muted');
      muted = false;
    }
    else{
      await _storage.write(key: 'muted',value: 'true');
      muted = true;
    }
  }
}