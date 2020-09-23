import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/Payback.dart';
import 'package:nupms_app/widgets/CardView.dart';
import 'package:nupms_app/widgets/ScheduleCard.dart';
import 'package:nupms_app/widgets/ScheduleDetailCard.dart';
import 'package:nupms_app/widgets/TitleBar.dart';
import 'package:provider/provider.dart';

class ScheduleDetailScreen extends StatelessWidget{
  MemberData memberData;
  ScheduleDetailScreen({this.memberData,this.totalAmount});
  double totalAmount;
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
              Text("${memberData.entrepreneurName}", style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: Colors.white70
              ),),
              Align(
                alignment: Alignment.centerRight,
                child: Text("${totalAmount} BDT",
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
                child: Text("${memberData.businessName}", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white70
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(top:5.0),
                child: Text("Ent-Code: ${memberData.code}", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white70
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(top:5.0,bottom: 20),
                child: Text("${getLocation(context)}", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white70
                ),),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: memberData.paybacks.length,
                    itemBuilder: (context,i){
                      Payback payback = memberData.paybacks[i];
                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top:10,bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: CardView(
                          baseHeight: 188,
                          contentHeight: 150,
                          text:"PAYBACK DATE  ${getDate(payback.paybackDate)}",
                          decoration: BoxDecoration(

                            color:Colors.white,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                          ),
                          card:ScheduleDetailCard(payback:payback,memberData:memberData),
                          contentBackground: Colors.white,
                          background: (payback.isDue && (payback.totalPayback-payback.collected)>0)? Color(0xffff6347) :
                          (payback.collected == payback.totalPayback)? Colors.green : Colors.indigoAccent,
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

  String getDate(String date){

    if(date != null){
      return DateFormat('dd MMMM, yyyy').format(DateTime.parse(date));
    }
    return "";
  }

  String getLocation(BuildContext context){
    return context.watch<AppData>().user.zoneName+ ", "+context.watch<AppData>().user.areaName+", "+ context.watch<AppData>().user.unitName;
  }

}