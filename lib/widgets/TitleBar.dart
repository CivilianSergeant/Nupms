import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:provider/provider.dart';

class TitleBar extends StatelessWidget{
  @override
  PreferredSizeWidget build(BuildContext context) {

    return AppBar(
      title: Center(child: Text("${context.watch<AppData>().Title}",textAlign: TextAlign.center,)),
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