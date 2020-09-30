import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupms_app/model/DepositData.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/UploadCollectionData.dart';
import 'package:provider/provider.dart';

class DepositCard extends StatelessWidget{
  MemberData memberData;
  String img;
  DepositCard({this.memberData,this.img});
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[

              Container(
                width: MediaQuery.of(context).size.width-40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (img != null )?
                        Image.asset(img,width: 100,height: 60,):
                        Container(width: 100,color: Colors.grey,
                          alignment: Alignment.center,
                          child: Text("Image"), height: 100,),
                        Text("${memberData.totalInvestment} BDT", style: TextStyle(
                        fontSize: 16,
                        color: Colors.indigoAccent,
                        fontWeight: FontWeight.w900
                    ),)
                  ],
                ),
              ),
            ]
          ),


        ],
      ),
    );
  }

  String getDate(String date){
    String _date = date;
    if(_date != null){
      return DateFormat('dd MMMM, yyyy').format(DateTime.parse(_date));
    }
    return "";
  }



}