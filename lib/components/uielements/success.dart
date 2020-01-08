import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import '../constants/trlang.dart';

class Success extends StatefulWidget{
  final Function onReplayClick;
    Success({Key key, @required this.onReplayClick}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
  
  }
  
  class _SuccessState extends State<Success> with TickerProviderStateMixin{
  GifController _controller;

  @override
  void initState(){
    _controller = GifController(vsync: this, duration: Duration(milliseconds: 3320));
    _controller.value = 0;
    _controller.animateTo(83);
    super.initState();
    Future.delayed(Duration(milliseconds: 3320)).then((any){

      showDialog(barrierDismissible: true, context: context,builder:(BuildContext context){
        return AlertDialog(
          title: Text(finishPopupTitle),
          content:Text(finishPopupText),
          actions: [
            FlatButton(child: Text(replayButtonText), onPressed: (){
              Navigator.pop(context);
              this.widget.onReplayClick();
            }),
            FlatButton(child: Text(returnToMenuButtonText), onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
            })
          ],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: GifImage(controller: this._controller, image: AssetImage('assets/confetti.gif')),
    );
  }
    
}