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
  final bool stopped;
  
  GameBoard({Key key, @required this.onPointChanged, this.onCompleted, this.playCount, this.stopped}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  
  final int _maxLevel = 3;
  final int _charCount = CharType.values.length;
  Map<CharType,int> _charStatus = new HashMap();
  int _currentPoint = 0;
  int _collectedPoint = 0;
  int _scoreDuration = 0;
  double _scoreOpacity = 0;
  bool _fail = false;
  bool _hideAnimatedContainer = true;
  bool _stopped = false;
  int _successfulClickCount = 0;

  @override
  void initState(){
    super.initState();

    for(int i = 0; i<_charCount;i++){
      _charStatus[CharType.values[i]] = 0;
    }
  }

  void didUpdateWidget(GameBoard oldWidget){
    super.didUpdateWidget(oldWidget);
    if(this.widget.playCount != 0 && this.widget.playCount != oldWidget.playCount){
      resetGame();
    }
    if(oldWidget.stopped != this.widget.stopped)
      this.setState((){
        this._stopped = this.widget.stopped;
      });
  }

  void resetGame(){
    this.setState((){
      this._currentPoint = 0;
      _charStatus = new HashMap();
      for(int i = 0; i<_charCount;i++){
        _charStatus[CharType.values[i]] = 0;
      }
      _currentPoint = 0;
      _collectedPoint = 0;
      _scoreDuration = 0;
      _scoreOpacity = 0;
      _fail = false;
      _hideAnimatedContainer = true;
      _stopped = false;
      _successfulClickCount = 0;
    });
  }

  void itemBump({int point, CharType type}){

    _collectedPoint = point;
    var currentStatus = _charStatus[type];

    if(currentStatus == _maxLevel){
      this.setState((){
        for(int i = 0; i<_charCount;i++){
          _charStatus[CharType.values[i]] = 0;
        }
        _successfulClickCount = _collectedPoint = _currentPoint = 0;
        this._fail = true;
      });
    }
    else{
      if(_successfulClickCount == (_charStatus.length*_maxLevel)-1){
        this.setState((){
          this._stopped = true;
          this._fail = false;
          _charStatus[type]++;
          _currentPoint = _collectedPoint + _currentPoint;
          _successfulClickCount++;
        });
        this.widget.onPointChanged(point:_currentPoint);
        this.widget.onCompleted();
        return;
      }
      else{
        this.setState((){
          this._fail = false;
          _charStatus[type]++;
          _currentPoint = _collectedPoint + _currentPoint;
          _successfulClickCount++;
        });
      }
    }
    if(this.widget.onPointChanged != null)
      this.widget.onPointChanged(point:_currentPoint);


    this.setState((){
      this._hideAnimatedContainer = false;
      this._scoreDuration = 10;
      this._scoreOpacity = 0.7;
    });
    Future.delayed(Duration(milliseconds: 40)).then((obj){
      this.setState((){
        this._scoreDuration = 140;
        this._scoreOpacity = 0.2;
      });
    });
  }

  TableRow rowWithCells(){
    return TableRow(
      children:[
        Cell(onBump: itemBump, stop:this._stopped, charCount:this._charCount),
        Cell(onBump: itemBump, stop:this._stopped, charCount:this._charCount),
        Cell(onBump: itemBump, stop:this._stopped, charCount:this._charCount),
      ]
    );
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          child:Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CharLabel(type: CharType.Dizdar,level: _charStatus[CharType.Dizdar], maxLevel: _maxLevel,),
                  CharLabel(type: CharType.Emin,level: _charStatus[CharType.Emin], maxLevel: _maxLevel,)
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CharLabel(type: CharType.Salih,level: _charStatus[CharType.Salih], maxLevel: _maxLevel,),
                  CharLabel(type: CharType.Asuman,level: _charStatus[CharType.Asuman], maxLevel: _maxLevel,),
                  CharLabel(type: CharType.Alaattin,level: _charStatus[CharType.Alaattin], maxLevel: _maxLevel,)
                ],
              )
            ]
          ),
        ),
        Expanded(
          flex: 1,
          child:Stack(
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
                child: CsText(_collectedPoint.toString(),textType: (this._fail)?TextType.BigFail:TextType.Big),
              ):Container(),
            ],
          ),
        )
      ],
    );
  }
}