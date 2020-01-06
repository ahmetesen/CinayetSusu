import 'package:cinayetsusu/components/managers/devicemanager.dart';
import 'package:cinayetsusu/components/uielements/cstext.dart';
import 'package:cinayetsusu/components/uielements/gameboard.dart';
import 'package:cinayetsusu/components/uielements/success.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/trlang.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _mute = DeviceManager().muted;
  int score = 0;
  bool _gameComplete = false;
  int _playCount = 0;
  
  void backRequested() {
    showDialog(barrierDismissible: true, context: context,builder:(BuildContext context){
      return AlertDialog(
        title: Text(warningTitle),
        content:Text(exitGameWarningText),
        actions: [
          FlatButton(child: Text(cancelButtonLabel), onPressed: (){
            Navigator.pop(context);
          }),
          FlatButton(child: Text(continueButtonLabel), onPressed: () async {
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
                          /* GestureDetector(
                            onTap: ()async{
                              await DeviceManager().toggleVolume();
                              this.setState((){
                                this._mute = !this._mute;
                              });
                            },
                            child: 
                              Container(
                                color: Color.fromARGB(0, 255, 255, 255),
                                margin: EdgeInsets.only(left: 4),
                                child:this._mute? Icon(
                                  Icons.volume_off,
                                  color:defaultTextColor
                                )
                                :Icon(
                                  Icons.volume_up,
                                  color:primaryForegroundColor
                                ),
                              )
                              
                            ,
                          ) */
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
                          child: GameBoard(playCount: this._playCount,
                            onPointChanged: ({int point}){
                              showScoreChange(point);
                            },
                            onCompleted: (){
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
                onReplayClick: (){
                  this.setState((){
                    _gameComplete = false;
                    _playCount++;
                    score = 0;
                  });

                  //TODO call reset state of GameBoard

                }
              ):Container()
            ],
          )
        )
      )
    );
  }
}