import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/widgets/CardView.dart';
import 'package:nupms_app/widgets/Sidebar.dart';
import 'package:nupms_app/widgets/TitleBar.dart';
import 'package:nupms_app/widgets/WelcomeCard.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {


  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

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
                  margin: EdgeInsets.all(10),
                  child: CardView(
                    baseHeight:140,
                    text: "Welcome",
                    contentHeight: 100,
                    background: Colors.indigoAccent,
                    card: WelcomeCard(),
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