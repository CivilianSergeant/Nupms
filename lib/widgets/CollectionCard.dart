import 'package:flutter/material.dart';
import 'package:nupms_app/entity/Payback.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/PaybackCollectionData.dart';
import 'package:provider/provider.dart';

class CollectionCard extends StatelessWidget {
  final MemberData member;
  CollectionCard({this.member});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: member?.pageController,
        pageSnapping: true,
        onPageChanged: (value) {
          if (member != null)
            context
                .read<PaybackCollectionData>()
                .updateCurrentPage(member, value: value);
        },
        scrollDirection: Axis.horizontal,
        itemCount: member?.paybacks?.length,
        itemBuilder: (context, j) {
          Payback payback = (member != null) ? member?.paybacks[j] : null;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Color(0xffcccccc)),
                    right: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Color(0xffcccccc)))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                      child: Text(
                                    "${payback.remaining}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
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
                                        "RECOVERABLE",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black54),
                                      ))
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                      child: Text(
                                    "${payback.totalPayback}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                        fontSize: 15),
                                  )),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey,
                                                width: 1,
                                                style: BorderStyle.solid))),
                                    child: Text("TOTAL PAYBACK",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black54)),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                      child: Text(
                                    "${payback.collected}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                        fontSize: 15),
                                  )),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey,
                                                width: 1,
                                                style: BorderStyle.solid))),
                                    child: Text("COLLECTED",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black54)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 21,
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          "PAYBACK DATE: ${payback.paybackDate.toUpperCase()}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      padding: EdgeInsets.only(top: 0, left: 10),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(
                              fontSize: 12,
                            ),
                            decoration:
                                InputDecoration(hintText: "Collection Date"),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(hintText: "Receipt No"),
                      ),
                    ),
                    Container(
                      width: 106,
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                  style: BorderStyle.solid))),
                      child: DropdownButton(
                        style: TextStyle(
                            height: 2, fontSize: 12, color: Colors.black),
                        value: payback.selectedType,
                        onChanged: (value) {
//                                        setState(() {
//                                          payback.selectedType = value;
//                                        });
                        },
                        items: context
                            .watch<PaybackCollectionData>()
                            .Types
                            .map((e) => DropdownMenuItem(
                                  value: e['id'],
                                  child: Text(e['name']),
                                ))
                            .toList(),
                        hint: Text("Col. Type"),
                        underline: SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(hintText: "DD / Cheque"),
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(hintText: "Amount"),
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(hintText: "Remark"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  String getInstallmentNo(Payback payback) {
    return (payback.installmentNo < 10)
        ? "0${payback.installmentNo}"
        : "${payback.installmentNo}";
  }
}
