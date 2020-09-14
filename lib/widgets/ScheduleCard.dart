import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/screens/ScheduleDetailScreen.dart';
import 'package:nupms_app/widgets/RoundedButton.dart';
import 'package:provider/provider.dart';

class ScheduleCard extends StatelessWidget{
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
              Text("Business Name", style: TextStyle(
                fontSize: 18,
                color: Colors.indigoAccent,
                fontWeight: FontWeight.w900
              ),),
              Text("Nowapara", style: TextStyle(
                fontWeight: FontWeight.w700,
                color:Colors.black54,
              ),)
            ]
          ),
          Spacer(),
          SizedBox(
            width: 120,

            child:RoundedButton(
              text: "Schedule",
              onPressed: (){
                context.read<AppData>().changeTitle("");
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=> ScheduleDetailScreen()
                ));
              },
            )
          )

        ],
      ),
    );
  }

}