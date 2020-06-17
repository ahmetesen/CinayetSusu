import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

class AnalysisToolsManager{
  final String _appMetricaApiKey = 'bc516d3c-da5d-4528-b21f-0e67b92015b4';
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  static AnalysisToolsManager _instance = AnalysisToolsManager._internal();
  factory AnalysisToolsManager() {
    return _instance ??= new AnalysisToolsManager._internal();
  }
  AnalysisToolsManager._internal();

  Future initializeAppMetrica() async {
    await AppmetricaSdk().activate(apiKey: this._appMetricaApiKey);
  }

  void sendCurrentScreenForAnalysis({@required String screenName, @required String classOverride}){
    analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: classOverride
    );
  }

  void sendGameOpenActionForAnalysis(){
    analytics.logAppOpen();
  }

  void sendLoginActionForAnalysis(){
    analytics.logLogin();
  }

  void sendLogoutActionForAnalysis(){
    analytics.logEvent(name: 'logout');
  }

  void sendSignUpActionForAnalysis(){
    analytics.logSignUp(signUpMethod: 'name');
  }

  void sendTutorialBeginActionForAnalysis(){
    analytics.logTutorialBegin();
  }

  void sendSkipTutorialActionForAnalysis({int score}){
    
    analytics.logEvent(name: 'skip_tutorial',parameters: <String, dynamic>{
        'score': score
      },);
  }

  void sendTutorialCompleteActionForAnalysis(){
    analytics.logTutorialComplete();
  }

  void sendGameStartActionForAnalysis(){
    analytics.logLevelStart(levelName: 'first');
  }

  void sendGameCompleteActionForAnalysis({@required int success}){
    analytics.logLevelEnd(levelName: 'first',success: success);
  }
}