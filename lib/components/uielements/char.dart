import 'package:cinayetsusu/components/models/chartype.dart';


class Char{
  final CharType type;
  int singleClickPoint;
  String imagePath;
  int showCount;
  int clickCount;

  Char({this.type}){
    switch(this.type){
      case CharType.Alaattin:
        singleClickPoint = 2;
        imagePath = 'assets/alaattin.png';
        break;
      case CharType.Dizdar:
        singleClickPoint = 5;
        imagePath = 'assets/dizdarkosu.png';
        break;
      case CharType.Emin:
        singleClickPoint = 4;
        imagePath = 'assets/emin.png';
        break;
      case CharType.Salih:
        singleClickPoint = 3;
        imagePath = 'assets/salih.png';
        break;
      case CharType.Asuman:
        singleClickPoint = 3;
        imagePath = 'assets/asuman.png';
        break;
      default:
        singleClickPoint = 0;
        imagePath = '';
        break;
    }
  }
}