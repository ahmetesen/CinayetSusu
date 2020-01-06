import 'package:cinayetsusu/components/constants/trlang.dart';
import 'package:cinayetsusu/components/models/score.dart';
import 'package:cinayetsusu/components/uielements/cstext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'userscore.dart';

class ScoreBoard extends StatefulWidget{
  final bool visible;
  final List<Score> scores;
  ScoreBoard({Key key, this.visible,this.scores}) : super(key: key);

  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  Widget build(BuildContext context) {
    if(this.widget.visible == false)
      return Container();
    List<Widget> userScoreItems = [];
    int order = 0;
    this.widget.scores.forEach((score){
      userScoreItems.add(UserScore(displayName: score.displayName,order: order,point: score.score));
      order++;
    });
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: CsText(todaysLeaders, textType: TextType.Title)
          ),          
          ...userScoreItems
        ],
      ),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      decoration: new BoxDecoration(
        border: Border.all(width: 0.1, color: new Color(0xFF0F1A56)),
        borderRadius: BorderRadius.all(new Radius.circular(8)),
        color:  new Color(0xFFFFFFFF)
      ),
    );
  }
}