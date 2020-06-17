import 'package:cinayetsusu/components/core/faderoute.dart';
import 'package:cinayetsusu/components/managers/analysistoolsmanager.dart';
import 'package:cinayetsusu/components/managers/devicemanager.dart';
import 'package:cinayetsusu/components/managers/gamemanager.dart';
import 'package:cinayetsusu/components/models/score.dart';
import 'package:cinayetsusu/components/screens/tutorialscreen.dart';
import 'package:cinayetsusu/components/uielements/cstext.dart';
import 'package:cinayetsusu/components/uielements/scoreboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../constants/colors.dart';
import '../constants/trlang.dart';
import '../uielements/logo.dart';
import 'gamescreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _focusNode = new FocusNode();
  bool scoreVisibility = true;
  bool scoreLoaded = false;
  String displayName;
  String inputVal;
  bool gameCheck = false;
  List<Score> scores = new List<Score>();

  bool _disableButton=false;
  _LoginScreenState(){
    displayName = DeviceManager().currentUser.displayName;
    GameManager().getTopTenUser().then((data){
      if(data != null)
        this.setState((){
          scores=data;
          scoreLoaded=true;
        });
      else
        this.setState(()=>scoreLoaded=false);
    });
  }

  @override
  void initState() {
    super.initState();
    AnalysisToolsManager().sendCurrentScreenForAnalysis(screenName: 'MainScreen',classOverride: 'loginscreen.dart');
    if(this.displayName != null && this.displayName.isNotEmpty){
      AnalysisToolsManager().sendLoginActionForAnalysis();
    }
    _focusNode.addListener((){
      this.setState((){
        scoreVisibility = !scoreVisibility;
      });
    });
  }

  Future formSubmit() async {
    if(gameCheck == true){
      final skipTutorial = await Navigator.push(
        context,
        FadeRoute(page:TutorialScreen()),
      );
    }
    if(_disableButton == true){
      FocusScope.of(context).requestFocus(new FocusNode());
      return;
    }

    this.setState((){
      _disableButton = true;
    });
    if(this.inputVal != null && this.inputVal.isNotEmpty){
      AnalysisToolsManager().sendSignUpActionForAnalysis();
      await DeviceManager().updateUsername(displayName:this.inputVal);
      this.displayName = this.inputVal; 
      this.inputVal = null;
      final skipTutorial = await Navigator.push(
        context,
        FadeRoute(page:TutorialScreen()),
      );
      if(skipTutorial != null && skipTutorial == true){
        await startGame();
      }
      else{
        var currentScore = await GameManager().getTopTenUser();
        this.setState((){
          scores = currentScore;
        });
      }
    }
    else if(this.displayName != null && this.displayName.isNotEmpty){
      await startGame();
    }

    this.setState((){
      _disableButton = false;
    });
  }

  Future startGame() async {
    final fromGameScreen = await Navigator.push(
      context,
      FadeRoute(page:GameScreen()),
    ); 
    var currentScore = await GameManager().getTopTenUser();
    this.setState((){
      scores = currentScore;
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child:Scaffold(
        backgroundColor:screenBackgroundColor,
        body:GestureDetector(
          onTap: ()=>
            FocusScope.of(context).requestFocus(new FocusNode()),
            behavior: HitTestBehavior.translucent,
          child:Padding(
            padding: EdgeInsets.all(0),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:<Widget>[
                Column(
                  children: <Widget>[
                    Logo(),
                    ScoreBoard(scores:scores,visible: (scoreVisibility && scoreLoaded))
                  ]
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      (displayName == null || displayName.isEmpty)?TextField(
                        maxLength: 20,
                        focusNode: _focusNode,
                        onChanged: (val){
                          this.inputVal = val;
                        },
                        onSubmitted: (val) async {
                          await this.formSubmit();
                        },
                        decoration: InputDecoration(
                          labelText: newUserWelcomeInputLabel,
                          hintText: newUserWelcomeInputHint,
                          labelStyle: TextStyle(color:primaryForegroundColor),
                          focusedBorder:UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryForegroundColor)
                          ),
                        
                        )
                        
                      ):CsText(oldUserWelcomeText+'$displayName!', textType: TextType.Title,),
                      Stack(
                        fit: StackFit.passthrough,
                        children: <Widget>[
                          Container(margin: EdgeInsets.fromLTRB(0, 8, 0, 8), 
                            child:RaisedButton(
                              color: secondaryForegroundColor,
                              child:CsText(playButtonLabel,textType: TextType.Button),
                              onPressed: () async {
                                await this.formSubmit();
                              },
                            )
                          ),
                        ],
                      ),
                      
                      (displayName != null && displayName.isNotEmpty)?
                        GestureDetector(
                          onTap: () {
                            showPlatformDialog(androidBarrierDismissible: true, context: context,builder:(BuildContext context){
                              return PlatformAlertDialog(
                                title: Text(warningTitle),
                                content:Text(deleteUserWarningText),
                                actions: [
                                  PlatformDialogAction(child: Text(cancelButtonLabel), onPressed: (){
                                    Navigator.pop(context);
                                  }),
                                  PlatformDialogAction(child: Text(deleteButtontext), onPressed: () async {
                                    AnalysisToolsManager().sendLogoutActionForAnalysis();
                                    await DeviceManager().deleteSavedUserOnDevice();
                                    Navigator.pop(context);
                                    this.setState(() {
                                      this.displayName = null;
                                    });
                                  })
                                ],
                              );
                            });
                          },
                          child:Container(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: CsText('$displayName'+deleteUserButtonLabel,textType: TextType.SubLink,),
                          )
                        )
                        :
                        Container()
                    ],
                  )
                )
              ]
            )
          )
        )
      ), onWillPop: () async {
        Navigator.pop(context);
        Navigator.pop(context);
        return true;
      },
    );
  }
}