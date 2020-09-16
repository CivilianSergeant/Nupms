import 'package:flutter/material.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/Payback.dart';
import 'package:nupms_app/model/PaybackCollectionData.dart';
import 'package:nupms_app/widgets/CollectionCard.dart';
import 'package:nupms_app/widgets/RoundedButton.dart';
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
      child: RoundedButton(
        color: Colors.indigoAccent,
        text: "COLLECT",
        onPressed: (){
          Payback payback = member.paybacks[member.currentPageNo];
          AppConfig.log(payback.toMap());
          AppConfig.log(('Current Page ${member.currentPageNo} sdfsf'));
          double offset = (member.currentPageNo+1)*340.0;
          member.pageController.animateTo(offset, duration: Duration(milliseconds:700), curve: Curves.easeInOut);
          context.read<PaybackCollectionData>().updateCurrentPage(member);
        },
      ),
    );
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