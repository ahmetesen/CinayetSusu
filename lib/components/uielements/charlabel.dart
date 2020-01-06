import 'package:cinayetsusu/components/models/chartype.dart';
import 'package:flutter/material.dart';

import 'bar.dart';
import 'cstext.dart';

class CharLabel extends StatefulWidget{
  final int level;
  final CharType type;
  CharLabel({Key key, this.type, this.level}) : super(key: key);

  @override
  _CharLabelState createState() => _CharLabelState();
}

class _CharLabelState extends State<CharLabel> {

  Widget build(BuildContext context) {
    
    String title = '';
    String name = '';

    switch(this.widget.type){
      case CharType.Alaattin:
        title='KOMISER YARDIMCISI';
        name='ALAATTIN';
        break;
      case CharType.Asuman:
        title='KOMISER';
        name='ASUMAN';
        break;
      case CharType.Dizdar:
        title='SUC UZMANI';
        name='DIZDAR KOSU';
        break;
      case CharType.Salih:
        title='KOMISER';
        name='SALIH';
        break;
      case CharType.Emin:
        title='BASKOMISER';
        name='EMIN';
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(margin: EdgeInsets.only(top:8), child: CsText(title,textType: (this.widget.level==3)?TextType.FilledCharTitle:TextType.CharTitle)),
        Container(margin: EdgeInsets.fromLTRB(0,4,0,4), child: CsText(name,textType: (this.widget.level==3)?TextType.FilledCharName:TextType.CharName,)),
        Container(margin: EdgeInsets.only(bottom: 8), child: Bar(level:this.widget.level))        
        
      ],
    );
  }
}