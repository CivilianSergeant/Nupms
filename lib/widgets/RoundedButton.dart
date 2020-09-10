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
        elevation: 5.0,
        color: (color!=null)? color : Colors.indigo,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          minWidth: 200.0,
          height: 20.0,
          onPressed: onPressed,
          child: Text(
            text, style: TextStyle(
            color: (textColor!=null) ? textColor : Colors.white70
          ),
          ),
        ),
      )
    );
  }
  
}