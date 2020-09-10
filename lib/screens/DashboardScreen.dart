import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/widgets/CardView.dart';
import 'package:nupms_app/widgets/Sidebar.dart';
import 'package:nupms_app/widgets/TitleBar.dart';
import 'package:provider/provider.dart';

class DahboardScreen extends StatefulWidget {


  @override
  _DahboardScreenState createState() => _DahboardScreenState();
}

class _DahboardScreenState extends State<DahboardScreen> {

  String _title = "NUPMS";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar().build(context),
      drawer: Sidebar(name:"User"),
      backgroundColor: Color(0xffafafcf),
      body: SingleChildScrollView(

          child: Column(
            children: [
              Container(

                  child: CardView(
                    baseHeight:170,
                    text: "Welcome",
                    contentHeight: 100,
                    background: Colors.teal,

                    contentBackground:Colors.transparent
                  ))
            ],
          )

      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 10),(){
      context.read<AppData>().changeTitle(_title);
    });

  }
}