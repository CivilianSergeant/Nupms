import 'package:flutter/material.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/Payback.dart';
import 'package:nupms_app/widgets/AmountTag.dart';

class ScheduleDetailCard extends StatelessWidget{
  MemberData memberData;
  Payback payback;
  ScheduleDetailCard({this.payback,this.memberData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              padding: EdgeInsets.only(left: 10, top: 10),
              child: CircleAvatar(
                  child: Text(
                    "${getInstallmentNo(payback)}",
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width-100,
                padding: EdgeInsets.only(top:10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10,),
                        AmountTag(amount:payback.investmentPB,text: "INVESTMENT PB",),
                        SizedBox(width: 10,),
                        AmountTag(amount:payback.otf,text: "OTF",),
                        Spacer(),
                        AmountTag(amount:payback.totalPayback,text: "TOTAL PAYABLE",)
                      ]
                    ),

                  ],
                ),

              )
            ]
          ),
          SizedBox(height: 15,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BigAmountTag(amount: (payback.totalPayback-payback.collected),amountSize: 30, text: "REMAINING",),
              BigAmountTag(amount: payback.collected, amountSize:30, text: "COLLECTED",)
            ],
          ),
          SizedBox(height: 5,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("DEPOSIT: ${payback.isDeposited? 'DONE': 'PENDING'}",style: TextStyle(
                color:Colors.black54
              ),),
              Text("TRANSIT: ${payback.isTransit? 'DONE': 'PENDING'}",style: TextStyle(
                  color:Colors.black54
              ),),
            ],
          )

        ],
      ),
    );
  }

}

String getInstallmentNo(Payback payback) {
  return (payback.installmentNo < 10)
      ? "0${payback.installmentNo}"
      : "${payback.installmentNo}";
}

class BigAmountTag extends StatelessWidget {
  const BigAmountTag({
    Key key,
    this.text,
    this.amountSize,
    this.amount
  }) : super(key: key);

  final String text;
  final double amountSize;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${amount}",style: TextStyle(
              fontSize:amountSize,
              color:Colors.blueGrey
          ),),
          Text("${text}", style: TextStyle(
            color:Colors.blueGrey
          ),)
        ],
      ),
    );
  }
}