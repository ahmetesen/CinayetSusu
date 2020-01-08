import 'dart:collection';

import 'package:cinayetsusu/components/constants/colors.dart';
import 'package:cinayetsusu/components/models/chartype.dart';
import 'package:cinayetsusu/components/uielements/cstext.dart';
import 'package:flutter/widgets.dart';

import 'cell.dart';
import 'charlabel.dart';

typedef PointChanged = Function({int point});

class GameBoard extends StatefulWidget{

  final PointChanged onPointChanged;
  final Function onCompleted;
  final int playCount;
  
  GameBoard({Key key, @required this.onPointChanged, this.onCompleted, this.playCount}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  Map<CharType,int> charStatus = new HashMap();
  int currentPoint = 0;
  int collectedPoint = 0;
  int _scoreDuration = 0;
  double _scoreOpacity = 0;
  bool _fail = false;
  bool _hideAnimatedContainer = true;
  bool _stopped = false;
  int successfulClickCount = 0;
  bool _gameComplete = false;
  final int maxLevel = 3;

  @override
  void initState(){
    super.initState();
    for(int i = 0; i<CharType.values.length;i++){
      charStatus[CharType.values[i]] = 0;
    }
  }

  void didUpdateWidget(GameBoard oldWidget){
    if(this.widget.playCount != 0 && this.widget.playCount != oldWidget.playCount){
      resetGame();
    }
  }

  void resetGame(){
    this.setState((){
      this.currentPoint = 0;
      charStatus = new HashMap();
      for(int i = 0; i<CharType.values.length;i++){
        charStatus[CharType.values[i]] = 0;
      }
      currentPoint = 0;
      collectedPoint = 0;
      _scoreDuration = 0;
      _scoreOpacity = 0;
      _fail = false;
      _hideAnimatedContainer = true;
      _stopped = false;
      successfulClickCount = 0;
      _gameComplete = false;
    });
  }

  void itemBump({int point, CharType type}){

    collectedPoint = point;
    var currentStatus = charStatus[type];

    if(currentStatus == maxLevel){
      this.setState((){
        for(int i = 0; i<CharType.values.length;i++){
          charStatus[CharType.values[i]] = 0;
        }
        successfulClickCount = collectedPoint = currentPoint = 0;
        this._fail = true;
      });
    }
    else{
      if(successfulClickCount == (CharType.values.length*maxLevel)-1){
        this.setState((){
          this._stopped = true;
          this._gameComplete = true;
          this._fail = false;
          charStatus[type]++;
          currentPoint = collectedPoint + currentPoint;
          successfulClickCount++;
        });
        this.widget.onCompleted();
        return;
      }
      else{
        this.setState((){
          this._fail = false;
          charStatus[type]++;
          currentPoint = collectedPoint + currentPoint;
          successfulClickCount++;
        });
      }
    }
    if(this.widget.onPointChanged != null)
      this.widget.onPointChanged(point:currentPoint);


    this.setState((){
      this._hideAnimatedContainer = false;
      this._scoreDuration = 10;
      this._scoreOpacity = 0.8;
    });
    Future.delayed(Duration(milliseconds: 40)).then((obj){
      this.setState((){
        this._scoreDuration = 200;
        this._scoreOpacity = 0.0;
      });
    });
  }

  TableRow rowWithCells(){
    return TableRow(
      children:[
        Cell(onBump: itemBump, stop:this._stopped),
        Cell(onBump: itemBump, stop:this._stopped),
        Cell(onBump: itemBump, stop:this._stopped),
      ]
    );
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: Table(
                border: TableBorder(horizontalInside: BorderSide(color: secondaryForegroundColor, width: 2),verticalInside: BorderSide(color: secondaryForegroundColor, width: 2)),
                children: [
                  rowWithCells(),
                  rowWithCells(),
                  rowWithCells()
                ],
              )
            ),
            (!_hideAnimatedContainer)?AnimatedOpacity(
              onEnd: (){
                this.setState((){
                  _hideAnimatedContainer = true;
                });
              },
              duration: Duration(milliseconds: _scoreDuration), 
              opacity: _scoreOpacity,
              child: CsText(collectedPoint.toString(),textType: (this._fail)?TextType.BigFail:TextType.Big),
            ):Container(),
        ],),
        
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CharLabel(type: CharType.Dizdar,level: charStatus[CharType.Dizdar]),
                CharLabel(type: CharType.Emin,level: charStatus[CharType.Emin])
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CharLabel(type: CharType.Salih,level: charStatus[CharType.Salih]),
                CharLabel(type: CharType.Asuman,level: charStatus[CharType.Asuman]),
                CharLabel(type: CharType.Alaattin,level: charStatus[CharType.Alaattin])
              ],
            )
          ]
        )
      ],
    );
  }
}