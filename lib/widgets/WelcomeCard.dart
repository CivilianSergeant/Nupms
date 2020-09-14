import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget{

  TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.w700,
    color: Colors.white70,
    fontSize: 12
  );

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal:10.0),
          child: Text("Employee Code",style: textStyle,),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("Employee Name",style: textStyle,),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("Zone", style: textStyle,),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal:10.0),
          child: Text("Area", style: textStyle,),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("Unit", style: textStyle,),
        ),
      ],
    );
  }

}