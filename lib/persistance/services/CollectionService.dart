import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nupms_app/config/ApiUrl.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/Payback.dart';
import 'package:nupms_app/model/ServiceResponse.dart';
import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/Collection.dart';
import 'package:nupms_app/persistance/tables/CollectionsTable.dart';
import 'package:nupms_app/services/network.dart';
import 'package:sqflite/sqflite.dart';

class CollectionService extends NetworkService{

  static Future<int> truncate() async {
    Database db = await DbProvider.db.database;
    return await db.delete(CollectionsTable().tableName);
  }

  static Future<List<Map<String,dynamic>>> getEntCodes() async {
    Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT DISTINCT m.entrepreneur_code from members m");
    return maps;
  }

  static Future<int> updateUploadedCollection() async {
    Database db = await DbProvider.db.database;
    return await db.update(CollectionsTable().tableName, {'is_synced':1},where: 'is_synced=0');
  }

  static Future<List<MemberData>> getCollection({String code,String date,bool isAll}) async{
    Database db = await DbProvider.db.database;
    List<MemberData> memberDatas = [];
    String _date = date;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT m.entrepreneur_id,m.entrepreneur_code, m.business_name, m.new_business_proposal_id, "
        " m.total_investment from members m ${(code!=null)? " WHERE m.entrepreneur_code='"+code+"'":''} ORDER BY entrepreneur_code ASC");
    int i=0;
       

    for(Map<String,dynamic> map in maps){

      String totalNoPayback = "(SELECT count(c.payback_id) totalNoPayback from collections c WHERE c.payback_id = s.payback_id) as totalNoPayback";
      String totalNoDeposited = "(SELECT sum(c.is_deposited) totalNoDeposited from collections c WHERE c.payback_id = s.payback_id) as totalNoDeposited";
      String totalNoTransit = "(SELECT sum(c.in_transit) totalNoTransit from collections c WHERE c.payback_id = s.payback_id) as totalNoTransit";

      String sql = "SELECT  ${totalNoPayback},${totalNoDeposited},${totalNoTransit}, (strftime(s.payback_date)<strftime('%Y-%m-%d','now')) due,s.investment_pb, s.otf, s.total_paybackable,("
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
//        AppConfig.log(element);
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


//      AppConfig.log(_paybacks);

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
    DateTime fromInitial = DateTime.now();
    fromInitial = DateTime(fromInitial.year,fromInitial.month,fromInitial.day-7);
    int fromStartYear = fromInitial.day;
    int fromEndYear = fromInitial.day+7;
    return Payback(
        remark: TextEditingController(),
        receiptNo: TextEditingController(),
        collectionAmount: TextEditingController(),
        collectionDate: TextEditingController(),
        ddCheque: TextEditingController(),
        entrepreneurId: map['entrepreneur_id'],
        entrepreneurCode: map['entrepreneur_code'],
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
        fromInitial: fromInitial,
        fromStartYear:(DateTime.parse("${fromInitial.year}-${(fromInitial.month<10)? '0${fromInitial.month}' : fromInitial.month}-${(fromStartYear<10)? '0${fromStartYear}': fromStartYear}").toIso8601String()),
        fromEndYear: (DateTime.parse("${fromInitial.year}-${(fromInitial.month<10)? '0${fromInitial.month}' : fromInitial.month}-${(fromEndYear<10)? '0${fromEndYear}': fromEndYear}").toIso8601String()),
        collected: (element['collected_amount'] != null)
            ? element['collected_amount']
            : 0,
        isDeposited: isDeposited(element),
        isTransit: inTransit(element)
    );
  }

  static bool isDeposited(Map<String,dynamic> element){
    if(element['totalNoPayback'] == element['totalNoDeposited']){
      return true;
    }
    return false;
  }

  static bool inTransit(Map<String,dynamic> element){
    if(element['totalNoPayback'] == element['totalNoTransit']){
      return true;
    }
    return false;
  }

  Future<Map<String,dynamic>> getNextPaybackId(int installmentNo, int paybackId) async{
    Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT s.payback_id , s.installment_no from schedules s"
        " WHERE s.payback_id=${paybackId} AND s.installment_no=${installmentNo}");

    return (maps!=null && maps.length>0)? maps.first : null;
  }

  static Future<double> getCollectionCount(String date) async{
    Database db = await DbProvider.db.database;
    String sql = "SELECT sum(c.collected_amount) as total from collections c "
        "where c.collection_date LIKE '${date}%' and c.is_synced=0";
    List<Map<String,dynamic>> maps = await db.rawQuery(sql);
    return (maps.length>0)? (((maps.first)['total']==null)?0:(maps.first)['total']):0;
  }

  static Future<double> getLastSevenDaysCollectionAmount(String currentDate) async{
    DateTime fromInitial = DateTime.parse(currentDate);
    fromInitial = DateTime(fromInitial.year,fromInitial.month,fromInitial.day-7);
    int fromStartYear = fromInitial.day;
    int fromEndYear = fromInitial.day+7;

    String startDate = (DateTime.parse("${fromInitial.year}-${(fromInitial.month<10)? '0${fromInitial.month}' : fromInitial.month}-${(fromStartYear<10)? '0${fromStartYear}': fromStartYear}").toIso8601String());
    String endDate = (DateTime.parse("${fromInitial.year}-${(fromInitial.month<10)? '0${fromInitial.month}' : fromInitial.month}-${(fromEndYear<10)? '0${fromEndYear}': fromEndYear}").toIso8601String());

    Database db = await DbProvider.db.database;
    String sql = "SELECT sum(c.collected_amount) as total from collections c "
        " WHERE strftime('%s',c.collection_date) <= strftime('%s','${endDate}') AND  strftime('%s',c.collection_date) >= strftime('%s','${startDate}')";
    List<Map<String,dynamic>> maps = await db.rawQuery(sql);

    maps.forEach((element) {
      AppConfig.log(element,line: '176',className: 'CollectionService');
    });
    return (maps.length>0)? (((maps.first)['total']==null)?0:(maps.first)['total']):0;
  }

  static Future<bool> saveCollection(Payback payback,{String date}) async{
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
        ddCheque: payback.ddCheque.text,
        bankingType: payback.bankingTypeName,
        newBusinessProposalId: payback.newBusinessProposalId,
        collectedAmount: collectionAmount,
        entrepreneurId: payback.entrepreneurId,
        remark: payback.remark.text,
        depositModeId: payback.selectedType,
        companyAccountId: payback.companyAccountId,
        isSynced: false,
        isDeposited: false,
        inTransit: false,
      ).toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    }else{

      // save advance payment of installment

      List<MemberData> result = await getCollection(code:payback.entrepreneurCode,date: date);
      MemberData memberData = result.length>0? result.first: null;
      if(memberData==null){
        return false;
      }

      AppConfig.log(memberData.paybacks);
      AppConfig.log(date);

      // find next installment paybackId
      for(Payback element in memberData.paybacks) {

        if(collectionAmount >= element.totalPayback){
          double remaining = (element.collected==0)? (collectionAmount -  element.totalPayback) : (collectionAmount-(element.totalPayback - element.collected));
          await db.insert(CollectionsTable().tableName,Collection(
            collectionDate: payback.collectionDate.text,
            receiptNo: payback.receiptNo.text,
            installmentNo: element.installmentNo,
            paybackId: element.paybackId,
            ddCheque: payback.ddCheque.text,
            bankingType: payback.bankingTypeName,
            newBusinessProposalId: element.newBusinessProposalId,
            collectedAmount: (element.collected==0)? element.totalPayback : (element.totalPayback-element.collected),
            entrepreneurId: element.entrepreneurId,
            remark: payback.remark.text,
            depositModeId: payback.selectedType,
            companyAccountId: payback.companyAccountId,
            isSynced: false,
            isDeposited: false,
            inTransit: false,
          ).toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
          AppConfig.log("PAID ${element.installmentNo} ${(element.collected==0)? element.totalPayback : (element.totalPayback-element.collected)}");
          collectionAmount = remaining;
          AppConfig.log("REMAINING BALANCE: ${collectionAmount}");
        }else{
          if(collectionAmount>0) {
            AppConfig.log("Balance ${element.installmentNo} ${collectionAmount}");

            await db.insert(CollectionsTable().tableName,Collection(
              collectionDate: payback.collectionDate.text,
              receiptNo: payback.receiptNo.text,
              installmentNo: element.installmentNo,
              paybackId: element.paybackId,
              ddCheque: payback.ddCheque.text,
              bankingType: payback.bankingTypeName,
              newBusinessProposalId: element.newBusinessProposalId,
              collectedAmount: collectionAmount,
              entrepreneurId: element.entrepreneurId,
              remark: payback.remark.text,
              depositModeId: payback.selectedType,
              companyAccountId: payback.companyAccountId,
              isSynced: false,
              isDeposited: false,
              inTransit: false,
            ).toMap(),conflictAlgorithm: ConflictAlgorithm.replace);

            collectionAmount=0;
          }
        }
      }

//      AppConfig.log("AFTER LOOP");
      return true;
    }
  }

  static Future<List<Map<String,dynamic>>> getUploadedCollections() async {
    Database db = await DbProvider.db.database;
    String sql = "SELECT m.entrepreneur_name, m.business_name, m.entrepreneur_code, c.* "
        "FROM collections c join members m ON m.entrepreneur_id = c.entrepreneur_id"
        " where is_synced = 0";
    return await db.rawQuery(sql);
  }

  Future<ServiceResponse> uploadCollection(Map<String,dynamic> uploadData) async {

      if(!await checkNetwork()){
        return ServiceResponse(
          status: 500,
          message: "Please Make sure internet connection is available"
        );
      }

      setUrl(getApiUrl('upload-collection'));
      Map<String,dynamic> result = await super.post(uploadData,header: {'Content-Type':'application/json'});
      AppConfig.log(result, line: '238',className: 'CollectionService');
      if(result == null){
        return ServiceResponse(
          status: 404,
          message: 'Sorry! Please Try Again Later.'
        );
      }
      if(result['status']==200){
        return ServiceResponse(
          status:200,
          message:'Collection Successfully Uploaded'
        );
      }else{
        AppConfig.log(result['message'],line:'289',className: 'CollectionService');
        AppConfig.log(result['messageDetails'],line:'290',className: 'CollectionService');
        return ServiceResponse(
          status: result['status'],
          message: result['message']+result['messageDetails']
        );
      }
  }

  static Future<int> updateDeposit(id, depositId) async{
    Database db = await DbProvider.db.database;
    return await db.update(CollectionsTable().tableName,
        {'is_deposited':1,'deposit_id':depositId},where: 'id=?',whereArgs: [id]);
  }

  static Future<List<Map<String,dynamic>>> getDepositDetails(int id) async{
    Database db = await DbProvider.db.database;
    return db.rawQuery("SELECT new_business_proposal_id as newBusinessProposalId, payback_id as paybackId, collected_amount as collectionAmount,"
        "collected_amount as depositAmount From collections WHERE deposit_id=${id}");

  }


}