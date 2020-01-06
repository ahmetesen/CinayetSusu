import 'dart:async';
import 'package:cinayetsusu/components/managers/fbmanager.dart';
import 'package:connectivity/connectivity.dart';

class ConnectionManager{
  StreamSubscription subscription;
  bool isOnline;
  bool isConnected;
  Timer timer;
  bool locked = false;
  static ConnectionManager _instance = ConnectionManager._internal();
  factory ConnectionManager() {
    return _instance ??= new ConnectionManager._internal();
  }
  ConnectionManager._internal();

  Future startListening() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    await getConnectivityResult(result: connectivityResult);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      await getConnectivityResult(result: result);
    });
    timer = Timer(Duration(seconds: 3), timerTick);
  }

  void timerTick() async {
    await checkInternetConnection();
  }

  Future getConnectivityResult({ConnectivityResult result}) async {
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      isConnected = true;
      isOnline = await checkInternetConnection();
    }
    else {
      isOnline = false;
      isConnected = false;
    }
  }

  Future<bool> checkInternetConnection() async {
    if(isOnline == false)
      return false;
    if(!locked){
      locked = true;
      var val = await FBManager().checkInternetConnection();
      locked = false;
      return val;
    }
    else
      return null;
  }

  void stopListening(){
    if(subscription != null)
      subscription.cancel();
    if(timer != null)
      timer.cancel();
  }
}