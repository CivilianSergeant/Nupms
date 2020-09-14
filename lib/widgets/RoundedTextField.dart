import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    Key key,
    this.hintText,
    this.isObscure,
    this.obscuringChar,
    @required this.controller,
    @required this.topMargin,
  }) : super(key: key);

  final bool isObscure;
  final String obscuringChar;
  final String hintText;
  final TextEditingController controller;
  final double topMargin;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top:topMargin,bottom: topMargin,left: 30,right: 30),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border(
                top: BorderSide(color: Colors.white70,width: 1,style: BorderStyle.solid),
                right: BorderSide(color: Colors.white70,width: 1,style: BorderStyle.solid),
                bottom: BorderSide(color: Colors.white70,width: 1,style: BorderStyle.solid),
                left: BorderSide(color: Colors.white70,width: 1,style: BorderStyle.solid)
            ),

          ),
          child: TextField(
            controller: controller,
            obscureText: (isObscure!=null)?isObscure:false,
            obscuringCharacter: (obscuringChar!=null)?obscuringChar:' ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,

            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                alignLabelWithHint: true,

                hintStyle: TextStyle(color: Colors.white70,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20)

            ),
          ),
        )
    );
  }
}