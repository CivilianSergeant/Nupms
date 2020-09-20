import 'package:flutter/material.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/Payback.dart';
import 'package:nupms_app/model/PaybackCollectionData.dart';
import 'package:nupms_app/persistance/services/CompanyBankAccountService.dart';
import 'package:nupms_app/widgets/AmountTag.dart';
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
                              AmountTag(amount: payback.remaining,text: "RECOVERABLE",),
                              SizedBox(
                                width: 10,
                              ),
                              AmountTag(amount: payback.totalPayback,text:"TOTAL PAYBACK"),
                              SizedBox(
                                width: 10,
                              ),
                              AmountTag(amount: payback.collected,text:"COLLECTED"),

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
                        padding: EdgeInsets.only(top: 10, left: 10,bottom: 10),
                        child: Text(
                          "PAYBACK DATE: ${payback.paybackDate.toUpperCase()}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: (payback.isDue)? Colors.redAccent:Colors.blueAccent),
                        )
                    ),
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
                            readOnly: true,
                            controller: payback.collectionDate,
                            onTap: (){
                              showDatePicker(context: context, initialDate:payback.fromInitial , firstDate: DateTime(payback.fromStartYear), lastDate: DateTime(payback.fromEndYear))
                                  .then((date){
                                if(date != null){
                                  payback.collectionDate.text = (date.toString().substring(0,11).trim());
                                    payback.fromInitial = DateTime.parse(payback.collectionDate.text);
                                  //                             getAgeInWords();
                                }else{
                                  payback.collectionDate.text="";
                                }
                              });
                            },
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
                        controller:payback.receiptNo,
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
                        onChanged: (value) async {
//                                        setState(() {

                              payback.selectedType = value;
                              context.read<PaybackCollectionData>().Types.forEach((element) async{
                                AppConfig.log(element);
                                if(element['deposit_mode_id'] == value && element['banking_type'] == 'Bank'){
                                  List<Map<String,dynamic>> companyBankAccounts = await CompanyBankAccountService.getCompanyBankAccounts(value);
                                  AppConfig.log(companyBankAccounts);
                                  payback.bankingType = true;
                                  AppConfig.log(value);
                                  context.read<PaybackCollectionData>().setCompanyBankAccounts(companyBankAccounts);
                                  context.read<PaybackCollectionData>().updateUI();
                                }else{
                                  payback.bankingType = false;
                                  context.read<PaybackCollectionData>().updateUI();
                                }
                              });

                              context.read<PaybackCollectionData>().updateUI();
//                                        });
                        },
                        items: context
                            .watch<PaybackCollectionData>()
                            .Types
                            .map((e) => DropdownMenuItem(
                                  value: e['deposit_mode_id'],
                                  child: Text(e['deposit_mode_name']),
                                ))
                            .toList(),
                        hint: Text("Deposit Mode"),
                        underline: SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
                (!payback.bankingType)? SizedBox(height: 35,) :
                Container(
                  height: 48,
                  margin: EdgeInsets.only(top:10,left: 10,right: 15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Colors.grey,
                              style: BorderStyle.solid))),
                  child: DropdownButton(
                    isExpanded: true,
                    style: TextStyle( fontSize: 12, color: Colors.black),
                    value: payback.companyAccountId,
                    onChanged: (value) {
                      payback.companyAccountId = value;
                      context.read<PaybackCollectionData>().updateUI();
                    },
                    items: context
                        .watch<PaybackCollectionData>()
                        .BankAccounts
                        .map((e) => DropdownMenuItem(
                      value: e['company_bank_id'],
                      child: Container(

                          height: 50,
                          alignment: Alignment.centerLeft,


                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text("${e['company_bank_name']},${e['company_bank_branch_name']}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text("${e['account_name']} - [${e['account_no']}]"),
                            ),
                            Divider()
                          ],
                        ),
                      ),
                    ))
                        .toList(),
                    hint: Text("Com. Bank Acc"),
                    underline: SizedBox.shrink(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        readOnly: payback.bankingType,
                        controller: payback.ddCheque,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(hintText: "DD / Cheque"),
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: payback.collectionAmount,
                        keyboardType:TextInputType.number,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(hintText: "Amount"),
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: payback.remark,
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


