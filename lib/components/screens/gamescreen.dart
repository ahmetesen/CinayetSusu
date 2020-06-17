import 'package:cinayetsusu/components/managers/analysistoolsmanager.dart';
import 'package:cinayetsusu/components/managers/gamemanager.dart';
import 'package:cinayetsusu/components/uielements/cstext.dart';
import 'package:cinayetsusu/components/uielements/gameboard.dart';
import 'package:cinayetsusu/components/uielements/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../constants/colors.dart';
import '../constants/trlang.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  bool _gameComplete = false;
  int _playCount = 0;
  bool _stopGame = false;

  @override
  void initState() {
    super.initState();
    AnalysisToolsManager().sendCurrentScreenForAnalysis(screenName: 'Game Screen',classOverride: 'gamescreen.dart');
    AnalysisToolsManager().sendGameStartActionForAnalysis();
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
            AnalysisToolsManager().sendGameCompleteActionForAnalysis(success: 0);
            Navigator.pop(context);
            Navigator.pop(context);
          })
        ],
      );
    });
  }

  void showScoreChange(int point){
    this.setState((){
      this.score = point;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          child: CsText(scoreLabel+score.toString(), textType: TextType.Title),
                        )]
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                          alignment: Alignment.center,
                          child: GameBoard(
                            stopped: this._stopGame,
                            playCount: this._playCount,
                            onPointChanged: ({int point}){
                              showScoreChange(point);
                            },
                            onCompleted: (){
                              GameManager().saveScore(currentScore:this.score).then((any){
                                GameManager().updateTopTenUser();
                                AnalysisToolsManager().sendGameCompleteActionForAnalysis(success: 1);
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
                score: score,
                onMainActionClick: (){
                  this.setState((){
                    _gameComplete = false;
                    _playCount++;
                    score = 0;
                  });
                }
              ):Container()
            ],
          )
        )
      )
    );
  }
}