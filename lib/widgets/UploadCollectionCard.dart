import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/UploadCollectionData.dart';
import 'package:provider/provider.dart';

class UploadCollectionCard extends StatelessWidget{
  MemberData memberData;
  UploadCollectionCard({this.memberData});
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
          CircleAvatar(
            child: Text(
              "${getInstallmentNo(memberData.installmentNo)}",
            ),
          ),
          SizedBox(width: 10,),
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
              Text("PAID BY ${getDate(memberData.collectionDate).toUpperCase()}", style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color:Colors.black54,
              ),)
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

  String getInstallmentNo(int  installmentNo) {
    return (installmentNo < 10)
        ? "0${installmentNo}"
        : "${installmentNo}";
  }

}