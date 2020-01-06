import 'package:cinayetsusu/components/models/score.dart';
import 'package:cinayetsusu/components/models/user.dart';
import 'package:cloud_functions/cloud_functions.dart';
class FBManager{
  static FBManager _instance = FBManager._internal();

  factory FBManager() {
    return _instance ??= new FBManager._internal();
  }
  FBManager._internal();

  //Simulator
/*   final HttpsCallable _createUser = CloudFunctions.instance.useFunctionsEmulator(origin: "http://localhost:8010").getHttpsCallable(functionName: "createUserAndSaveToDb");
  final HttpsCallable _getFirstTenUser = CloudFunctions.instance.useFunctionsEmulator(origin: "http://localhost:8010").getHttpsCallable(functionName: "getFirstTenUser");
  final HttpsCallable _ping = CloudFunctions.instance.useFunctionsEmulator(origin: "http://localhost:8010").getHttpsCallable(functionName: "ping");
  final HttpsCallable _updateUser = CloudFunctions.instance.useFunctionsEmulator(origin: "http://localhost:8010").getHttpsCallable(functionName: "updateUser");
  final HttpsCallable _saveUserPoint = CloudFunctions.instance.useFunctionsEmulator(origin: "http://localhost:8010").getHttpsCallable(functionName: "saveUserPoint");
 */

  //Device
  
  final HttpsCallable _createUser = CloudFunctions.instance.getHttpsCallable(functionName: "createUserAndSaveToDb");
  final HttpsCallable _getFirstTenUser = CloudFunctions.instance.getHttpsCallable(functionName: "getFirstTenUser");
  final HttpsCallable _ping = CloudFunctions.instance.getHttpsCallable(functionName: "ping");
  final HttpsCallable _updateUser = CloudFunctions.instance.getHttpsCallable(functionName: "updateUser");
  final HttpsCallable _saveUserPoint = CloudFunctions.instance.getHttpsCallable(functionName: "saveUserPoint");


  Future<bool> checkInternetConnection() async {
    try{
      await _ping.call();
      return true;
    }
    catch(error){
      return false;
    }
  }

  Future<String> createUser({User user}) async {
    try{
      HttpsCallableResult result = await _createUser.call(user.toJson());
      if(result.data != null)
        return result.data;
      else
        throw null;
    }
    catch(error){
      throw error;
    }
    
  }

  Future <List<Score>> getFirstTenUser() async {
    try{
      HttpsCallableResult result = await _getFirstTenUser.call();
      if(result.data != null){
        var data = result.data.map<Score>((item)=>Score.fromJson(item)).toList();
        return data;
      }
      else
        return null;
    }
    catch(error){
      return null;
    }
  }

  Future updateUser(User user) async {
    await _updateUser.call(user.toJson());
  }

  Future saveUserPoint(Score score) async {
    await _saveUserPoint.call(score.toJson());
  }
}