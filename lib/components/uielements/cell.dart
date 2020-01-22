import 'dart:async';
import 'dart:math';
import 'package:cinayetsusu/components/models/chartype.dart';
import 'package:cinayetsusu/components/uielements/char.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

typedef Bump = void Function({@required CharType type, @required int point});

class Cell extends StatefulWidget{
  final Bump onBump;
  final bool stop;
  final int charCount;
  Cell({Key key, this.onBump, this.stop, this.charCount}) : super(key: key);

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> with TickerProviderStateMixin{

  Char activeChar;
  List<Char> chars = new List<Char>();
  Timer _showTimer;
  Stopwatch _clickStopWatch = new Stopwatch();
  GifController controller;
  bool _visible=false;
  bool _charVisible = false;
  List<String> bangImagePaths = ['assets/bam1.png','assets/bam2.png','assets/bam3.png','assets/bam4.png','assets/bam5.png'];
  String _randomBangImage;

  @override
  void initState(){
    super.initState();
    controller = GifController(vsync: this, duration: Duration(milliseconds: 400));
    for(int i = 0 ; i < this.widget.charCount; i++){
      chars.add(new Char(type: CharType.values[i]));
    }
    if(this.widget.stop == false)
      beginShow();
  }

  @override
  void didUpdateWidget(Cell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.stop == true && this.widget.stop == false)
      beginShow();
  }

  void beginShow(){
    if(_showTimer != null)
      _showTimer.cancel();
    
    int randomlyNull = Random().nextInt(3);
    if(randomlyNull != 0){
      endShow();
      return;
    }
    _clickStopWatch.start();
    controller.value = 0;
    controller.animateTo(8);
    _showTimer = new Timer(Duration(milliseconds:(Random().nextInt(200))+2000),endShow);
    this.setState((){
      activeChar = chars[Random().nextInt(this.widget.charCount)];
    });
    Future.delayed(Duration(milliseconds: 20)).then((sth){
      this.setState((){
        _charVisible = true;
      });
    });
  }

  void endShow({bool permanentlyEnd = false}){
    if(_showTimer != null)
      _showTimer.cancel();
    if(controller.isAnimating){
      controller.stop();
      controller.reset();
    }
    
    _clickStopWatch.reset();
    _clickStopWatch.stop();
    

    this.setState((){
      _charVisible = false;
      activeChar = null;
      this._visible = false;
    });
    if(this.widget.stop != true)
      _showTimer = new Timer(Duration(milliseconds:(Random().nextInt(100))+3000),beginShow);
  }

  Future whenBump() async {
    if(this.widget.onBump != null && activeChar != null){
      int _point = calculatePoint();
      this.widget.onBump(point:_point, type:activeChar.type);
      if(_point<100)
        HapticFeedback.lightImpact();
      else if(_point < 200)
        HapticFeedback.mediumImpact();
      else
        HapticFeedback.heavyImpact();
      _randomBangImage = bangImagePaths[Random().nextInt(5)];
      this.setState((){
        this._visible = true;
      });
      await Future.delayed(Duration(milliseconds: 200));
      endShow();
    }
  }

  int calculatePoint(){
    int multiplier = 3000000000;
    int result = ((multiplier*activeChar.singleClickPoint)/(_clickStopWatch.elapsedMilliseconds*_clickStopWatch.elapsedMilliseconds*_clickStopWatch.elapsedMilliseconds)).floor();
    return result*10;
  }

  @override 
  void dispose(){
    if(_showTimer != null)
      _showTimer.cancel();
    if(controller.isAnimating){
      controller.stop();
      controller.reset();
    }
    _clickStopWatch.stop();
    _clickStopWatch.reset();
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    if(this.widget.stop == true){
      return Container(width: 80,height: 80);
    }
    return GestureDetector(
      onTap: () async {
        await whenBump();
      },
      child: Container(
        margin: EdgeInsets.all(2),
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child:(activeChar!=null)?Stack(
          alignment: Alignment.center,
          children:[
            Image( 
              image:AssetImage(activeChar.imagePath),
              color: Color.fromARGB((_charVisible)?255:0, 255, 255, 255),
              colorBlendMode: BlendMode.modulate
            ),
            GifImage(
              width: 80,
              height: 80, 
              controller: controller,
              image: AssetImage('assets/explode.gif'),
            ),
            this._visible?Image(image:AssetImage(_randomBangImage)):Container()
          ]
        ):null
      ),
    );
  }
}