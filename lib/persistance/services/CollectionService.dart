import 'package:flutter/material.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/Payback.dart';
import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:sqflite/sqflite.dart';

class CollectionService{

  static Future<List<Map<String,dynamic>>> getEntCodes() async {
    Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT DISTINCT m.entrepreneur_code from members m");
    return maps;
  }
  static Future<List<MemberData>> getCollection({String code,String date}) async{
    Database db = await DbProvider.db.database;
    List<MemberData> memberDatas = [];
    String _date = date;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT m.entrepreneur_id,m.entrepreneur_code, m.business_name, m.new_business_proposal_id "
        "from members m ${(code!=null)? ' WHERE m.entrepreneur_code='+code:''} ORDER BY entrepreneur_code ASC");
    int i=0;


    for(Map<String,dynamic> map in maps){
//      AppConfig.log(map);



      String sql = "SELECT (strftime(s.payback_date)<strftime('%Y-%m-%d','now')) due, s.total_paybackable,("
          "SELECT sum(collected_amount) collected_amount FROM collections c WHERE c.payback_id = s.payback_id GROUP BY c.installment_no"
          ") collected_amount ,s.payback_date,s.installment_no, s.payback_id from schedules s "
          "WHERE (strftime('%s',s.payback_date) <= strftime('%s','${_date}')) AND s.entrepreneur_id="+map['entrepreneur_id'].toString();

      List<Map<String,dynamic>> scheduleMaps = await db.rawQuery(sql);
      List<Payback> _paybacks = [];
      scheduleMaps.forEach((element) {
        if(element['collected_amount']== null || (element['collected_amount'] < element['total_paybackable'])) {
          double remaingingBalance = (element['collected_amount']!=null)? (element['total_paybackable'] - element['collected_amount']) : element['total_paybackable'];
          _paybacks.add(Payback(
              remark: TextEditingController(),
              receiptNo: TextEditingController(),
              collectionAmount: TextEditingController(),
              collectionDate: TextEditingController(),
              ddCheque: TextEditingController(),
              entrepreneurId: map['entrepreneur_id'],
              paybackId: element['payback_id'],
              newBusinessProposalId: map['new_business_proposal_id'],
              isDue: (element['due']==1)? true:false,
              remaining: remaingingBalance,
              totalPayback: element['total_paybackable'],
              paybackDate: element['payback_date'],
              installmentNo: element['installment_no'],
              fromInitial: DateTime.now(),
              fromStartYear: DateTime.now().year,
              fromEndYear: (DateTime.now().year+1),
              collected: (element['collected_amount']!=null)? element['collected_amount'] : 0
          ));
        }
      });
//      AppConfig.log(scheduleMaps);

//      AppConfig.log("__________________________");
      MemberData memberData = MemberData(
          businessName: map['business_name'].toString().trim(),
          code: map['entrepreneur_code'],
          pageController: PageController(),
          paybacks: _paybacks
      );
      if(_paybacks.length>0) {
        memberDatas.add(memberData);
      }
      i++;
    }
    return memberDatas;
  }

  Future<Map<String,dynamic>> getNextPaybackId(int installmentNo, int paybackId) async{
    Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT s.payback_id , s.installment_no from schedules s"
        " WHERE s.payback_id=${paybackId} AND s.installment_no=${installmentNo}");

    return (maps!=null && maps.length>0)? maps.first : null;
  }

  static Future<double> getCollectionCount() async{
    Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT sum(c.collected_amount) as total from collections c "
        "where strftime('%s',c.collection_date) = strftime('%s','now')");
    return (maps.length>0)? (((maps.first)['total']==null)?0:(maps.first)['total']):0;
  }


}