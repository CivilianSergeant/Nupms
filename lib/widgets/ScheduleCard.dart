import 'package:flutter/material.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/persistance/services/CollectionService.dart';
import 'package:nupms_app/screens/ScheduleDetailScreen.dart';
import 'package:nupms_app/widgets/RoundedButton.dart';
import 'package:provider/provider.dart';

class ScheduleCard extends StatelessWidget{
  MemberData memberData;
  ScheduleCard({this.memberData});
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[

              Container(
                width: 170,
                child: Text("${memberData.entrepreneurName}", style: TextStyle(
                  fontSize: 16,
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w900
                ),),
              ),
              Text("${memberData.unitName}", style: TextStyle(
                fontWeight: FontWeight.w700,
                color:Colors.black54,
              ),),
              SizedBox(height: 10,),
              Text("${memberData.totalInvestment} BDT", style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color:Colors.black54,
              ),),
              SizedBox(height: 2,),
              Text("TOTAL INVESTMENT", style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color:Colors.black54,
              ),)
            ]
          ),
          Spacer(),
          SizedBox(
            width: 118,

            child:RoundedButton(
              text: "Schedule",

              onPressed: () async{
                context.read<AppData>().changeTitle("");
                List<MemberData> members = await CollectionService.getCollection(code: memberData.code,isAll: true);
                double totalCollection =0;
                if(members.length>0){
                  memberData.paybacks = members.first.paybacks;
                  memberData.paybacks.forEach((element) {
//                    AppConfig.log(element.toMap());
                    totalCollection+= element.collected;
                  });
                }
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=> ScheduleDetailScreen(memberData: memberData,totalAmount: totalCollection,)
                ));
              },
            )
          )

        ],
      ),
    );
  }

}