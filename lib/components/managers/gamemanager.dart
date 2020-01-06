import 'package:cinayetsusu/components/managers/fbmanager.dart';
import 'package:cinayetsusu/components/models/score.dart';

class GameManager{
  List<Score> _topTenUsers;
  static GameManager _instance = GameManager._internal();
  factory GameManager() {
    return _instance ??= new GameManager._internal();
  }
  GameManager._internal();

  Future<List<Score>> getTopTenUser() async{
    if(this._topTenUsers == null){
      await updateTopTenUser();
    }
    return this._topTenUsers;
  }

  Future<List<Score>> updateTopTenUser() async{
    if(this._topTenUsers == null){
      this._topTenUsers = new List<Score>();
    }
    this._topTenUsers = await FBManager().getFirstTenUser();
    return this._topTenUsers;
  }
}