import 'package:cinayetsusu/components/constants/colors.dart';
import 'package:flutter/material.dart';

class Bar extends StatefulWidget{
  final int level;
  final int maxLevel;
  Bar({Key key, this.level, this.maxLevel}) : super(key: key);

  @override
  _BarState createState() => _BarState();
}

class _BarState extends State<Bar> {

  Widget emptyBarPart(){
    return Container(
      width: 20,
      height: 2,
      color:defaultSubTextColor,
      margin: EdgeInsets.only(right: 2),
    );
  }

  Widget collectedBarPart(){
    return Container(
      width: 20,
      height: 3,
      margin: EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: secondaryForegroundColor,
        border: Border.all(
          color: primaryForegroundColor,
          width: .5,
        )
      ),
    );
  }

  Widget build(BuildContext context) {
    int level = 0;
    if(this.widget.level!=null)
      level = this.widget.level;
    List<Container> bars = new List<Container>();
    for(int i = 0; i<this.widget.maxLevel;i++){
      if(i<level)
        bars.add(collectedBarPart());
      else
        bars.add(emptyBarPart());
    }

    return 
    Row(
      children: bars
    );
    
  }
}