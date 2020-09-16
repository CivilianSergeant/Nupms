import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:provider/provider.dart';

class WelcomeCard extends StatelessWidget{

  TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.w700,
    color: Colors.white70,
    fontSize: 16
  );

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal:10.0),
          child: Text("${context.watch<AppData>().user.employeeName} (${context.watch<AppData>().user.employeeCode})",style: textStyle,),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("${context.watch<AppData>().user.zoneName},"
              "${context.watch<AppData>().user.areaName}, "
              "${context.watch<AppData>().user.unitName}", style: textStyle,),
        ),

      ],
    );
  }

}