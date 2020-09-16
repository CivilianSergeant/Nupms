import 'package:flutter/material.dart';

class BadgeTile extends StatelessWidget{

  String text;
  String amount;
  Color color;
  BadgeTile({
    this.text,
    this.amount,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10)
      ),
      width: ((MediaQuery.of(context).size.width/2)-20),
      child: Column(
        children: <Widget>[

          Container(
            alignment: Alignment.centerRight,
            height: 25,
            padding: EdgeInsets.only(bottom: 0,right: 10),
            child: Text("${amount}",style: TextStyle(color: Colors.indigoAccent,
                fontWeight: FontWeight.w900,
                fontSize: 20),),
          ),
          SizedBox(height: 10,),
          Divider(),
          Container(
            padding: EdgeInsets.only(bottom: 5,right: 10),
            alignment: Alignment.centerRight,
            child: Text("${text.toUpperCase()}",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.indigoAccent),),
          )
        ],
      ),
    );
  }

}