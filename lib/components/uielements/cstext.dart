import 'package:flutter/widgets.dart';
import '../constants/colors.dart';

enum TextType{
  Title,
  Regular,
  SubText,
  SubLink,
  Button,
  CharTitle,
  CharName,
  FilledCharTitle,
  FilledCharName,
  Big,
  BigFail
}

class CsText extends StatelessWidget{
  final String data;
  final TextType textType;
  Color _foreground = defaultTextColor;
  double _fontSize = 11;
  FontWeight _fontWeight = FontWeight.normal;
  FontStyle _fontStyle = FontStyle.normal;
  CsText(this.data,{Key key,this.textType}):super(key:key){
    switch(this.textType){
      case TextType.Big:
        this._foreground = primaryForegroundColor;
        _fontWeight = FontWeight.normal;
        _fontSize = 64;
      break;
      case TextType.BigFail:
        this._foreground = Color.fromARGB(255, 255, 0, 0);
        _fontWeight = FontWeight.normal;
        _fontSize = 76;
      break;
      case TextType.Title:
        this._foreground = primaryForegroundColor;
        _fontSize = 18;
      break;
      case TextType.SubText:
        this._foreground = defaultSubTextColor;
        _fontSize = 12;
      break;
      case TextType.SubLink:
        this._foreground = defaultSubLinkColor;
        _fontSize = 14;
      break;
      case TextType.Button:
        this._foreground = primaryForegroundColor;
        _fontSize = 14;
        _fontWeight = FontWeight.bold;
      break;
      case TextType.CharTitle:
        _fontSize = 10;
        _fontWeight = FontWeight.w300;
        _fontStyle = FontStyle.italic;
        _foreground = defaultSubTextColor;
      break;
      case TextType.CharName:
        _fontSize = 12;
        _fontWeight = FontWeight.w300;
        _fontStyle = FontStyle.normal;
        _foreground = defaultSubTextColor;
      break;
      case TextType.FilledCharName:
        _fontSize = 12;
        _fontWeight = FontWeight.w300;
        _fontStyle = FontStyle.normal;
        _foreground = primaryForegroundColor;
      break;
      case TextType.FilledCharTitle:
        _fontSize = 10;
        _fontWeight = FontWeight.w300;
        _fontStyle = FontStyle.italic;
        _foreground = primaryForegroundColor;
      break;
      default:
      
      break;
    }
  }

  @override
  Widget build(BuildContext context){
    return(
      Text(
        data,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: this._fontSize,
          color: this._foreground,
          fontWeight: this._fontWeight,
          fontStyle: this._fontStyle,
          decoration: TextDecoration.none
        )
      )
    );
  }
}