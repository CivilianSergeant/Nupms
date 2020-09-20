import 'package:flutter/material.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/Payback.dart';
import 'package:nupms_app/model/PaybackCollectionData.dart';
import 'package:nupms_app/persistance/services/CollectionService.dart';
import 'package:nupms_app/widgets/CollectionCard.dart';
import 'package:nupms_app/widgets/RoundedButton.dart';
import 'package:nupms_app/widgets/ToastMessage.dart';
import 'package:provider/provider.dart';

class CardView extends StatelessWidget{

  MemberData member;
  String text;
  bool showFooter;
  double contentHeight;
  double baseHeight;
  Color background;
  BoxDecoration decoration;
  Color contentBackground;
  Widget card;
  CardView({this.member,this.text,
    this.contentHeight,
    this.baseHeight,
    this.background,
    this.decoration,
    this.contentBackground,
    this.card,
    this.showFooter});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      height: baseHeight,
//      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(color: Color(0x2f000000),offset: Offset.fromDirection(1), blurRadius: 5,spreadRadius: 1)
        ],
        color: background,
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CollectionItemTitle(text:text,member: member,),

          Container(
            width: MediaQuery.of(context).size.width,
            height: contentHeight,

            decoration: decoration,
            child: card
          ),
          CollectionItemFooter(member: member,show: showFooter,)
        ],
      ),
    );
  }



}

class CollectionItemFooter extends StatelessWidget {
  const CollectionItemFooter({
    Key key,
    this.show,
    @required this.member,
  }) : super(key: key);

  final bool show;
  final MemberData member;

  @override
  Widget build(BuildContext context) {
    return (show==null || !show)? SizedBox.shrink() : Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
        color:Colors.white70,
      ),
      padding: EdgeInsets.only(left:5,right:(MediaQuery.of(context).size.width-150)),
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: (member.currentPageNo>0)? SizedBox.shrink(): RoundedButton(
        color: Colors.indigoAccent,
        text: "COLLECT",
        onPressed: () async{
          Payback payback = member.paybacks[member.currentPageNo];
          AppConfig.log("CurrentPageNo ${member.currentPageNo}");
          AppConfig.log(payback.toMap());
          if(validate(payback,context)){ //

            AppConfig.log(('Current Page ${member.currentPageNo} sdfsf'));

            bool status = await CollectionService.saveCollection(payback);
            if(status) {
              context.read<AppData>().updateTotalCollection(payback.collectionDate.text);
              double collectionAmount = double.parse(payback.collectionAmount.text);
              double recoverable = payback.remaining;

              List<MemberData> updatedRecords = await CollectionService
                  .getCollection(code: member.code, date: context.read<PaybackCollectionData>().selectedDate);
              MemberData lastestRecord = (updatedRecords.length > 0)
                  ? updatedRecords.first
                  : null;

              if(collectionAmount>=recoverable) {
                double offset = 340.0;
//                AppConfig.log("BEFORE ANIMATE ${member.currentPageNo}");
//                await member.pageController.animateTo(
//                    offset, duration: Duration(milliseconds: 700),
//                    curve: Curves.easeInOut);
//                AppConfig.log("AFTER ANIMATE ${member.currentPageNo}");
              }

              await Future.delayed(Duration(milliseconds: 800),(){
                AppConfig.log("BEFORE Update ${member.currentPageNo}");
                context.read<PaybackCollectionData>().updateMemberPayback(member,lastestRecord);
                AppConfig.log("AFTER Update ${member.currentPageNo}");
              });


              if(collectionAmount>=recoverable) {
                context.read<PaybackCollectionData>().updateCurrentPage(member, value: 0);
              }
            }
          }

        },
      ),
    );
  }

  bool validate(Payback payback, BuildContext context){
    AppConfig.log(payback.toMap());
    double totalPayback = payback.totalPayback;
    double collected = payback.collected;
    double collectionAmount = (payback.collectionAmount.text.length>0)? double.parse(payback.collectionAmount.text):0;
    double recoverable = payback.remaining;

    AppConfig.log(payback.collectionDate.text.trim().length);
    if(payback.collectionDate.text.trim().length==0){
      ToastMessage.showMesssage(status: 500,message:'Please Select Collection Date',context: context);
      return false;
    }

    if(payback.receiptNo.text.trim().length==0){
      ToastMessage.showMesssage(status: 500,message:'Please Write Receipt No',context: context);
      return false;
    }

    if(payback.selectedType==null){
      ToastMessage.showMesssage(status: 500,message:'Please Select Deposit Type',context: context);
      return false;
    }

    if(payback.collectionAmount.text.trim().length==0){
      ToastMessage.showMesssage(status: 500,message:'Collection Amount Required',context: context);
      return false;
    }

    if(totalPayback < (collected+collectionAmount)){
      double remaingingAmount = (collected+collectionAmount)-totalPayback;
      AppConfig.log(remaingingAmount);
      String msg = "Collection Amount should not exceed total pabyack of installment. you can collect ${remaingingAmount} for next installment";
      ToastMessage.showMesssage(status: 500,message:msg,context: context);
      return false;
    }

    return true;
  }
}

class CollectionItemTitle extends StatelessWidget {
  const CollectionItemTitle({
    Key key,
    this.text,
    @required this.member,
  }) : super(key: key);

  final String text;
  final MemberData member;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (text!=null)? showText() : showMemberInfo()
      ),
    );
  }

  List<Widget> showText(){
    return [
      Text("${text}",style:TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w900
      ),),
    ];
  }

  List<Widget> showMemberInfo(){
    return [Text("${member?.businessName}",style:TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w900
    ),),
    Text("Ent-Code: ${member?.code}",style:TextStyle(
    color: Colors.white70,
    fontWeight: FontWeight.w900
    ),)];
  }
}