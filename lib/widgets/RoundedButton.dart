import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget{
  final Color color;
  final String text;
  final Color textColor;
  final Function onPressed;
  RoundedButton({this.color, @required this.text, this.textColor, @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child:Material(
        clipBehavior:Clip.hardEdge,
        elevation: 5.0,

        color: (color!=null)? color : Colors.indigo,
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
          width: 200,
          height: 50,
          child: FlatButton(

            onPressed: onPressed,
            child: Text(
              text, style: TextStyle(
              color: (textColor!=null) ? textColor : Colors.white70
            ),
            ),
          ),
        ),
      )
    );
  }
  
}