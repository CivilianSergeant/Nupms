import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:provider/provider.dart';

class TitleBar extends StatelessWidget{

  Color color;
  double elevation;
  Function onPressed;
  bool showSearch;
  IconData icon;
  TitleBar({this.color,this.elevation,this.showSearch,this.onPressed,this.icon});

  @override
  PreferredSizeWidget build(BuildContext context) {

    List<Widget> actions = [

    ];
    if(showSearch!=null && showSearch) {
      actions.add(IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      ));
    }else{
      actions.add(SizedBox(width: 40,));
    }
    return AppBar(
      elevation: (elevation != null)? elevation: 5,
      title: Center(child: Text("${context.watch<AppData>().Title}",textAlign: (actions.length>0)? TextAlign.center : TextAlign.start,)),
      backgroundColor: (color!=null)? color: Colors.indigo,
      actions: actions,
    );
  }

}