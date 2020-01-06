import 'package:flutter/widgets.dart';

enum CharacterType{
  DizdarKosu,
  Alaattin,
  Salih,
  Asuman,
  Emin
}

class Target extends StatefulWidget{
  final CharacterType type;
  Target({Key key, this.type}) : super(key: key);

  @override
  _TargetState createState() => _TargetState();
}

class _TargetState extends State<Target> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}