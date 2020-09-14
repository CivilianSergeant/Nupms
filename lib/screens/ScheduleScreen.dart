import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/screens/DashboardScreen.dart';
import 'package:nupms_app/widgets/CardView.dart';
import 'package:nupms_app/widgets/ScheduleCard.dart';
import 'package:nupms_app/widgets/Sidebar.dart';
import 'package:nupms_app/widgets/TitleBar.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AppData>().changeTitle("NUMPS");
        return true;
      },
      child: Scaffold(
        appBar: TitleBar(
          elevation: 0,
          color: Colors.indigo,).build(context),
//        drawer: Sidebar(),
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  margin: EdgeInsets.all(10),
                  child: CardView(
                    member:MemberData(
                      businessName: "Rifat Sayem",
                      code: "19239219"
                    ),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                    ),
                    card:ScheduleCard(),
                    contentBackground: Colors.white,
                    background: Colors.indigoAccent,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}