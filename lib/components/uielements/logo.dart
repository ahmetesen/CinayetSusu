import 'package:flutter/widgets.dart';

class Logo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
    padding:new EdgeInsets.fromLTRB(0, 40, 0, 24),
    child: 
      Image(
        image: AssetImage('assets/logo.png'),
      ),
    );
  }
}