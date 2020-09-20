import 'package:flutter/material.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/Payback.dart';
import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/Collection.dart';
import 'package:nupms_app/persistance/tables/CollectionsTable.dart';
import 'package:sqflite/sqflite.dart';

class CollectionService{

  static Future<List<Map<String,dynamic>>> getEntCodes() async {
    Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT DISTINCT m.entrepreneur_code from members m");
    return maps;
  }
  static Future<List<MemberData>> getCollection({String code,String date,bool isAll}) async{
    Database db = await DbProvider.db.database;
    List<MemberData> memberDatas = [];
    String _date = date;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT m.entrepreneur_id,m.entrepreneur_code, m.business_name, m.new_business_proposal_id, "
        " m.total_investment from members m ${(code!=null)? " WHERE m.entrepreneur_code='"+code+"'":''} ORDER BY entrepreneur_code ASC");
    int i=0;
       

    for(Map<String,dynamic> map in maps){
             



      String sql = "SELECT (strftime(s.payback_date)<strftime('%Y-%m-%d','now')) due,s.investment_pb, s.otf, s.total_paybackable,("
          "SELECT sum(collected_amount) collected_amount FROM collections c WHERE c.payback_id = s.payback_id GROUP BY c.installment_no"
          ") collected_amount ,s.payback_date,s.installment_no, s.payback_id from schedules s ";
      sql += "WHERE  s.entrepreneur_id="+map['entrepreneur_id'].toString();

      if(_date != null) {
        sql +=
        " AND (strftime('%s',s.payback_date) <= strftime('%s','${_date}'))";
      }

      List<Map<String,dynamic>> scheduleMaps = await db.rawQuery(sql);
      List<Payback> _paybacks = [];
      scheduleMaps.forEach((element) {
        if(isAll!=null && isAll){
          double remainingBalance = (element['collected_amount'] != null)
              ? (element['total_paybackable'] - element['collected_amount'])
              : element['total_paybackable'];
            _paybacks.add(_getPayback(remainingBalance, element, map));
        }else {
          if (element['collected_amount'] == null ||
              (element['collected_amount'] < element['total_paybackable'])) {
            double remainingBalance = (element['collected_amount'] != null)
                ? (element['total_paybackable'] - element['collected_amount'])
                : element['total_paybackable'];
            _paybacks.add(_getPayback(remainingBalance, element, map));
          }
        }

      });
//      AppConfig.log(scheduleMaps);

//      AppConfig.log("__________________________");
      MemberData memberData = MemberData(
          businessName: map['business_name'].toString().trim(),
          code: map['entrepreneur_code'],
          totalInvestment: map['total_investment'],
          pageController: PageController(),
          paybacks: _paybacks,
          currentPageNo: 0
      );
      if(_paybacks.length>0) {
        memberDatas.add(memberData);
      }
      i++;
    }
    return memberDatas;
  }

  static Payback _getPayback(double remainingBalance, Map<String,dynamic> element,Map<String,dynamic> map){
    return Payback(
        remark: TextEditingController(),
        receiptNo: TextEditingController(),
        collectionAmount: TextEditingController(),
        collectionDate: TextEditingController(),
        ddCheque: TextEditingController(),
        entrepreneurId: map['entrepreneur_id'],
        paybackId: element['payback_id'],
        newBusinessProposalId: map['new_business_proposal_id'],
        isDue: (element['due'] == 1) ? true : false,
        remaining: remainingBalance,
        totalPayback: element['total_paybackable'],
        paybackDate: element['payback_date'],
        installmentNo: element['installment_no'],
        investmentPB: element['investment_pb'],
        otf: element['otf'],
        bankingType: false,
        fromInitial: DateTime.now(),
        fromStartYear: DateTime
            .now()
            .year,
        fromEndYear: (DateTime
            .now()
            .year + 1),
        collected: (element['collected_amount'] != null)
            ? element['collected_amount']
            : 0
    );
  }

  Future<Map<String,dynamic>> getNextPaybackId(int installmentNo, int paybackId) async{
    Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT s.payback_id , s.installment_no from schedules s"
        " WHERE s.payback_id=${paybackId} AND s.installment_no=${installmentNo}");

    return (maps!=null && maps.length>0)? maps.first : null;
  }

  static Future<double> getCollectionCount(String date) async{
    Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT sum(c.collected_amount) as total from collections c "
        "where c.collection_date LIKE '${date}%'");
    return (maps.length>0)? (((maps.first)['total']==null)?0:(maps.first)['total']):0;
  }

  static Future<bool> saveCollection(Payback payback) async{
    Database db = await DbProvider.db.database;
    double collectionAmount = double.parse(payback.collectionAmount.text);
    double recoverable = payback.remaining;

    if(collectionAmount <= recoverable && collectionAmount <= payback.totalPayback){
      // save full/partial payment of installment

      await db.insert(CollectionsTable().tableName,Collection(
        collectionDate: payback.collectionDate.text,
        receiptNo: payback.receiptNo.text,
        installmentNo: payback.installmentNo,
        paybackId: payback.paybackId,
        newBusinessProposalId: payback.newBusinessProposalId,
        collectedAmount: collectionAmount,
        entrepreneurId: payback.entrepreneurId,
        remark: payback.remark.text,
        depositModeId: payback.selectedType,
        companyAccountId: payback.companyAccountId,
        isSynced: false,
      ).toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    }else{
      // find next installment paybackId

      // save advance payment of installment


    }
  }

  static Future<List<Map<String,dynamic>>> getUploadedCollections() async {
    Database db = await DbProvider.db.database;
    String sql = "SELECT m.entrepreneur_name, m.business_name, m.entrepreneur_code, c.* "
        "FROM collections c join members m ON m.entrepreneur_id = c.entrepreneur_id"
        " where is_synced = 0";
    return await db.rawQuery(sql);
  }


}