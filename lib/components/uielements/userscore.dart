import 'package:cinayetsusu/components/uielements/cstext.dart';
import 'package:flutter/widgets.dart';

class UserScore extends StatelessWidget{
  final String displayName;
  final int point;
  final int order;
  UserScore({@required this.displayName, @required this.point, @required this.order});

  List<Widget> badges(){
    List<Widget> result = [];
    var pointContainer = Container(
        margin:EdgeInsets.fromLTRB(4, 4, 0, 4),
        child:CsText(this.point.toString(), textType: TextType.Regular)
      );
    if(this.order>2){
      result.add(pointContainer);
      return result;
    }

    for(int i = 3; i>order; i--){
      result.add(
        Container(
          width: 12,
          height: 12,
          child:Image(
            fit: BoxFit.none,
            image: AssetImage('assets/polisrozet.png'),
          )
        )
      );
    }
    result.add(pointContainer);
    return result;
  }  

  @override
  Widget build(BuildContext context){
    var _badges = this.badges();
    return Container(
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CsText(this.displayName,textType: TextType.Regular),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ..._badges
            ],
          )
        ],
      )
    );
  }
}