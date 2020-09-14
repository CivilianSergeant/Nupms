import 'package:flutter/material.dart';
import 'package:nupms_app/entity/Payback.dart';

class AmountTag extends StatelessWidget {
  const AmountTag({
    Key key,
    this.color,
    this.amountColor,
    @required this.amount,
    @required this.text
  }) : super(key: key);

  final Color color;
  final double amount;
  final Color amountColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: Text(
              "${amount}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: (amountColor!=null)? amountColor: Colors.black54,
                  fontSize: 15),
            )),
        Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Colors.grey,
                        width: 1,
                        style: BorderStyle.solid))),
            child: Text(
              "${text}",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.black54),
            ))
      ],
    );
  }
}