import 'dart:async';
import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:cinayetsusu/components/core/faderoute.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cinayetsusu/components/managers/devicemanager.dart';
import 'package:cinayetsusu/components/managers/gamemanager.dart';
import 'package:cinayetsusu/components/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cinayetsusu/components/loaders/simpleloader.dart';
import 'components/constants/colors.dart';
import 'components/uielements/logo.dart';

void main() async {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  WidgetsFlutterBinding.ensureInitialized();
  await AppmetricaSdk()
      .activate(apiKey: 'bc516d3c-da5d-4528-b21f-0e67b92015b4');
  runApp(MaterialApp(home: MyApp(),));
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool started = false;
  bool loaded = false;
  Timer timer;

  void timerTick(){
    this.setState(() => started=true);
    timer.cancel();
  }

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    super.initState();

    try{
      DeviceManager().initializeUserAndDeviceInfo().then((data){
        GameManager().updateTopTenUser().then((subData){
          Navigator.push(
            context,
            FadeRoute(page:LoginScreen()),
          );
        });
      });
    }
    catch(err){
      //TODO:Implement catches
    }
      
  }

  @override
  Widget build(BuildContext context) {
    if(!started)
      timer = Timer(Duration(milliseconds: 100), timerTick);
    return Stack(
      alignment: Alignment.center,
      children:<Widget>[
        AnimatedContainer(
          duration:Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          color:screenBackgroundColor,
          alignment: (started)?Alignment.topCenter:Alignment.center,
          child:Logo(),
        ),
        Center(child: SimpleLoader(visible: (started)?(!loaded):false))
      ]
    );
  }
}