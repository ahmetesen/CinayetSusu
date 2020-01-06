import 'package:flutter/widgets.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import '../constants/colors.dart';

class SimpleLoader extends StatelessWidget{
  SimpleLoader({@required this.visible, Key key}) : super(key: key);
  final visible;

  @override
  Widget build(BuildContext context){
    return AnimatedOpacity(
      duration:Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      opacity: this.visible ? 1.0 : 0.0,
      child:Loading(indicator: BallSpinFadeLoaderIndicator(), size: 40.0, color: secondaryForegroundColor )
    );
  }
}