import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/widgets/CardView.dart';
import 'package:nupms_app/widgets/ScheduleCard.dart';
import 'package:nupms_app/widgets/ScheduleDetailCard.dart';
import 'package:nupms_app/widgets/TitleBar.dart';
import 'package:provider/provider.dart';

class ScheduleDetailScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        context.read<AppData>().changeTitle("Schedule");
        return true;
      },
      child: Scaffold(
        appBar: TitleBar(
        elevation: 0,
        color: Colors.indigo,).build(context),
        backgroundColor: Colors.indigo,
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Rifat Sayem", style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: Colors.white70
              ),),
              Align(
                alignment: Alignment.centerRight,
                child: Text("0.00 BDT",
                  textAlign: TextAlign.right,
                  style: TextStyle(

                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                    color: Colors.white70
                ),),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top:2.0),
                  child: Text("TOTAL COLLECTION", style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      color: Colors.white70
                  ),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: Text("Business Name", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white70
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(top:5.0),
                child: Text("Ent-Code: 19239219", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white70
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(top:5.0,bottom: 20),
                child: Text("Zone Name, Area Name, Unit Name", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white70
                ),),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context,i){
                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top:10,bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: CardView(
                          baseHeight: 186,
                          contentHeight: 150,
                          text:"PAYBACK DATE   03 DEC, 2020",
                          decoration: BoxDecoration(

                            color:Colors.white,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                          ),
                          card:ScheduleDetailCard(),
                          contentBackground: Colors.white,
                          background: Colors.indigoAccent,
                        ),
                      ),
                    );
                })
              )

            ],
          ),
        ) ,
      ),
    );
  }

}