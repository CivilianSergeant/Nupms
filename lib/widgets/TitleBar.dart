import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:provider/provider.dart';

class TitleBar extends StatelessWidget{

  Color color;
  double elevation;
  TitleBar({this.color,this.elevation});

  @override
  PreferredSizeWidget build(BuildContext context) {

    return AppBar(
      elevation: (elevation != null)? elevation: 5,
      title: Center(child: Text("${context.watch<AppData>().Title}",textAlign: TextAlign.center,)),
      backgroundColor: (color!=null)? color: Colors.indigo,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: (){

          },
        )
      ],
    );
  }

}