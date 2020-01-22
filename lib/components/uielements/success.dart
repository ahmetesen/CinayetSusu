import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../constants/trlang.dart';

class Success extends StatefulWidget{
  final Function onMainActionClick;
  final int score;
  final bool tutorial;
    Success({Key key, @required this.onMainActionClick,@required this.score, this.tutorial}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
  
  }
  
  class _SuccessState extends State<Success> with TickerProviderStateMixin{
  GifController _controller;

  @override
  void initState(){
    super.initState();
    String title = '';
    String description = '';
    String action1 = '';
    String action2 = '';
    _controller = GifController(vsync: this, duration: Duration(milliseconds: 3320));
    _controller.value = 0;
    _controller.animateTo(83);
    if(this.widget.tutorial == true){
      title = tutorialFinishPopupTitle;
      description = tutorialFinishPopupDescription;
      action1 = returnToMenuButtonText;
      action2 = startGameButtonText;
    }
    else{
      title = finishPopupTitle + this.widget.score.toString();
      description = finishPopupText;
      action1 = returnToMenuButtonText;
      action2 = replayButtonText;

    }
    Future.delayed(Duration(milliseconds: 1000)).then((any){

      showPlatformDialog(androidBarrierDismissible: true, context: context,builder:(BuildContext context){
        return PlatformAlertDialog(
          title: Text(title),
          content:Text(description),
          actions: [
            PlatformDialogAction(child: Text(action1), onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            }),
            PlatformDialogAction(child: Text(action2), onPressed: () async {
                Navigator.pop(context);
                this.widget.onMainActionClick();
            })
          ],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GifImage(controller: this._controller, image: AssetImage('assets/confetti.gif')),
    );
  }
    
}