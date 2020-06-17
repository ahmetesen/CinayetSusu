import 'package:cinayetsusu/components/managers/analysistoolsmanager.dart';
import 'package:cinayetsusu/components/managers/gamemanager.dart';
import 'package:cinayetsusu/components/uielements/cstext.dart';
import 'package:cinayetsusu/components/uielements/success.dart';
import 'package:cinayetsusu/components/uielements/tutorialgameboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../constants/colors.dart';
import '../constants/trlang.dart';

class TutorialScreen extends StatefulWidget {
  TutorialScreen({Key key}) : super(key: key);
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {

  int _score = 0;
  bool _gameComplete = false;
  bool _dialog1 = true;
  bool _dialog2 = false;
  int _correctHit = 0;
  int _wrongHit = 0;
  bool _stopGame = true;

  void initState() {
    super.initState();
    AnalysisToolsManager().sendCurrentScreenForAnalysis(screenName: 'Tutorial Screen',classOverride: 'tutorialscreen.dart');
    AnalysisToolsManager().sendTutorialBeginActionForAnalysis();
  }
  
  void backRequested() {
    this.setState((){
      this._stopGame = true;
    });
    
    showPlatformDialog(androidBarrierDismissible: true, context: context,builder:(BuildContext context){
      GameManager().updateTopTenUser();
      return PlatformAlertDialog(
        title: Text(warningTitle),
        content:Text(exitGameWarningText),
        actions: [
          PlatformDialogAction(child: Text(cancelButtonLabel), onPressed: (){
            this.setState((){
              this._stopGame = false;
            });
            Navigator.pop(context);
          }),
          PlatformDialogAction(child: Text(continueButtonLabel), onPressed: () async {
            AnalysisToolsManager().sendSkipTutorialActionForAnalysis(score:this._score);
            Navigator.pop(context);
            Navigator.pop(context);
          })
        ],
      );
    });
  }

  void showScoreChange(int point){
    this.setState((){
      this._score = point;
      if(point == 0){
        this._wrongHit++;
      }
      else if(point > 0){
        this._correctHit++;
      }
    });
  }

  void showFirstPopup(){
    Future.delayed(Duration(milliseconds: 10)).then((any)async{
      await showPlatformDialog(androidBarrierDismissible: false, context: context,builder:(BuildContext context){
        return PlatformAlertDialog(
          title: Text(tutorialPopupTitle),
          content:Text(tutorialPopupText),
          actions: [
            PlatformDialogAction(child: Text(skipTutorialButtonLabel), onPressed: (){
              Navigator.pop(context);
              skipTutorial();
            }),
            PlatformDialogAction(child: Text(continueButtonLabel), onPressed: () async {
              Navigator.pop(context);
              this.setState((){
                this._stopGame = false;
                this._dialog2 = true;
              });
            })
          ],
        );
      });
    });
  }

  void showSecondPopup(){
    Future.delayed(Duration(milliseconds: 100)).then((any)async{
      await showPlatformDialog(androidBarrierDismissible: false, context: context,builder:(BuildContext context){
        return PlatformAlertDialog(
          title: Text(tutorialSecondPopupTitle),
          content:Text(tutorialSecondPopupText),
          actions: [
            PlatformDialogAction(child: Text(skipTutorialButtonLabel), onPressed: (){
              Navigator.pop(context);
              skipTutorial();
            }),
            PlatformDialogAction(child: Text(continueButtonLabel), onPressed: () async {
              Navigator.pop(context);
            })
          ],
        );
      });
    });
  }

  void showCorrectHitPopup(){
    Future.delayed(Duration(milliseconds: 100)).then((any)async{
      await showPlatformDialog(androidBarrierDismissible: false, context: context,builder:(BuildContext context){
        return PlatformAlertDialog(
          title: Text(tutorialCorrectPopupTitle),
          content:Text(tutorialCorrectPopupDescription),
          actions: [
            PlatformDialogAction(child: Text(skipTutorialButtonLabel), onPressed: (){
              Navigator.pop(context);
              skipTutorial();
            }),
            PlatformDialogAction(child: Text(continueButtonLabel), onPressed: () async {
              Navigator.pop(context);
            })
          ],
        );
      });
    });
  }

  void showWrongHitPopup(){
    Future.delayed(Duration(milliseconds: 100)).then((any)async{
      await showPlatformDialog(androidBarrierDismissible: false, context: context,builder:(BuildContext context){
        return PlatformAlertDialog(
          title: Text(tutorialWrongPopupTitle),
          content:Text(tutorialWrongPopupDescription),
          actions: [
            PlatformDialogAction(child: Text(skipTutorialButtonLabel), onPressed: (){
              Navigator.pop(context);
              skipTutorial();
            }),
            PlatformDialogAction(child: Text(continueButtonLabel), onPressed: () async {
              Navigator.pop(context);
            })
          ],
        );
      });
    });
  }


  void skipTutorial(){
    AnalysisToolsManager().sendSkipTutorialActionForAnalysis(score:this._score);
    Navigator.pop(context,true);
  }

  @override
  Widget build(BuildContext context) {
    if(_dialog1 == true){
      _dialog1 = false;
      showFirstPopup();
    }
    if(_dialog2 == true){
      _dialog2 = false;
      showSecondPopup();
    }

    if(_correctHit == 1){
      _correctHit++;
      showCorrectHitPopup();
    }

    if(_wrongHit == 1){
      _wrongHit++;
      showWrongHitPopup();
    }

    return WillPopScope(
      onWillPop: () async {
        backRequested();
        return false;
      },
      child: Scaffold(
        backgroundColor:screenBackgroundColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(12, 40, 12, 30),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              backRequested();
                            },
                            child: Icon(
                              Icons.home,
                              color: primaryForegroundColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children:<Widget>[
                          Container(
                          child: CsText(scoreLabel+_score.toString(), textType: TextType.Title),
                        )]
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                          alignment: Alignment.center,
                          child: TutorialGameBoard(
                            stopped:_stopGame,
                            playCount: 0,
                            onPointChanged: ({int point}){
                              showScoreChange(point);
                            },
                            onCompleted: (){
                              GameManager().saveScore(currentScore:this._score).then((any){
                                GameManager().updateTopTenUser();
                              });
                              this.setState((){
                                this._gameComplete = true;
                              });
                            },
                          ),
                        ),
                  )
                ],
              ),
              (this._gameComplete)?Success(
                tutorial:true,
                score: _score,
                onMainActionClick: (){
                  AnalysisToolsManager().sendTutorialCompleteActionForAnalysis();
                  Navigator.pop(context,true);
                }
              ):Container()
            ],
          )
        )
      )
    );
  }
}