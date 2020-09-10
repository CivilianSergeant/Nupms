import 'package:flutter/material.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/PaybackCollectionData.dart';
import 'package:nupms_app/widgets/CardView.dart';
import 'package:nupms_app/widgets/CollectionCard.dart';
import 'package:provider/provider.dart';

class Collection extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: context.watch<PaybackCollectionData>().Members.length,
        itemBuilder: (context, i){

          MemberData member = context.watch<PaybackCollectionData>().Members[i];
          if( member.currentPageNo==null) {
            member.currentPageNo = i;
          }
          return CardView(
            member:member,
            baseHeight: 298,
            contentHeight:198,
            background: Colors.indigoAccent,
            contentBackground: Colors.white,
            card: CollectionCard(member: member,),
            showFooter: true,);
        });
  }

}