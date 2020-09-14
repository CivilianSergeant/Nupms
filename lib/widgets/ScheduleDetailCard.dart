import 'package:flutter/material.dart';
import 'package:nupms_app/widgets/AmountTag.dart';

class ScheduleDetailCard extends StatelessWidget{
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
                    "01",
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
                        AmountTag(amount:40000,text: "INVESTMENT PB",),
                        SizedBox(width: 10,),
                        AmountTag(amount:8000,text: "OTF",),
                        Spacer(),
                        AmountTag(amount:48000,text: "TOTAL PAYABLE",)
                      ]
                    ),

                  ],
                ),

              )
            ]
          ),
          SizedBox(height: 20,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BigAmountTag(amount: 48000,amountSize: 30, text: "REMAINING",),
              BigAmountTag(amount: 0, amountSize:30, text: "PAID",)
            ],
          )

        ],
      ),
    );
  }

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