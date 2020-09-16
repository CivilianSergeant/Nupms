import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/LoginDataNotifier.dart';
import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/Collection.dart';
import 'package:nupms_app/persistance/entity/Investment.dart';
import 'package:nupms_app/persistance/entity/Member.dart';
import 'package:nupms_app/persistance/entity/Schedule.dart';
import 'package:nupms_app/persistance/tables/CollectionsTable.dart';
import 'package:nupms_app/persistance/tables/InvestmentsTable.dart';
import 'package:nupms_app/persistance/tables/MembersTable.dart';
import 'package:nupms_app/persistance/tables/SchedulesTable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';

class MemberService{

  static Future<void> removeMembers() async{
    Database db = await DbProvider.db.database;

    await db.delete(InvestmentsTable().tableName);
    AppConfig.log("${InvestmentsTable().tableName} removed");
    await db.delete(SchedulesTable().tableName);
    AppConfig.log("${SchedulesTable().tableName} removed");
    await db.delete(CollectionsTable().tableName);
    AppConfig.log("${CollectionsTable().tableName} removed");
    await db.delete(MembersTable().tableName);
    AppConfig.log("${MembersTable().tableName} removed");
  }

  static Future<Map<String,dynamic>> addMembers(BuildContext context, List<dynamic> members) async {
     Database db = await DbProvider.db.database;
     int memberCount=0;
     int investmentCount=0;
     int scheduleCount=0;
     int collectionCount=0;


     AppConfig.log("Members : ${members.length}");

     for(dynamic element in members){
       Map<String,dynamic> map = (Member(
         entrepreneurId: element['entrepreneurId'],
         newBusinessProposalId: element['newBusinessProposalId'],
         entrepreneurCode: element['entrepreneurCode'],
         entrepreneurName: element['entrepreneurName'],
         businessName: element['businessName'],
         approvedInvestment: element['approvedInvestment'],
         currency: element['currency'],
         investmentDuration: element['investmentDuration'],
         totalInvestment: element['totalInvestment'],
         phaseNo:element['phaseNo']
       ).toMap());

       int memberId = await db.insert(MembersTable().tableName, map);
       if(memberId>0){
         AppConfig.log("MemberID: ${memberId}");
         memberCount++;

         Batch investmentBatch = db.batch();

         if(element['investments'] == null && element['schedules'] == null){
           continue;
         }

         for(dynamic investment in element['investments']){
            Map<String,dynamic> _investment = (Investment(
              newBusinessProposalId: investment['newBusinessProposalId'],
              chequeNo: investment['chequeNo'],
              amount: investment['amount'],
              remainingAmount: investment['remainingAmount'],
              accumulated: investment['accumulated'],
              placementDate: investment['placementDate'],
              entrepreneurId: element['entrepreneurId'],
            ).toMap());

            investmentBatch.insert(InvestmentsTable().tableName, _investment);
            investmentCount++;
         }
         await investmentBatch.commit(noResult: true);


         Batch scheduleBatch = db.batch();
         Batch collectionBatch = db.batch();
         for(dynamic schedule in element['schedules']){
            String paybackDate = schedule['paybackable']['date'];


            paybackDate = _correctDateFormat(paybackDate);



            Map<String,dynamic> _schedule = (Schedule(
              entrepreneurId: element['entrepreneurId'],
              installmentNo: schedule['installmentNo'],
              paybackId: schedule['paybackId'],
              paybackDate: paybackDate,
              investmentPB: schedule['paybackable']['investmentPB'],
              otf: schedule['paybackable']['otf'],
              totalPaybackAble: schedule['paybackable']['totalAmount'],
            ).toMap());



            scheduleBatch.insert(SchedulesTable().tableName, _schedule);
            scheduleCount++;



            if(schedule['payback'] !=null) {
              String collectionDate = schedule['payback']['collectionDate'];
              collectionDate = _correctDateFormat(collectionDate);
              Map<String, dynamic> _collection = (Collection(
                  entrepreneurId: element['entrepreneurId'],
                  paybackId: schedule['paybackId'],
                  installmentNo: schedule['installmentNo'],
                  collectedAmount: schedule['payback']['amount'],
                  collectionDate: collectionDate
              ).toMap());

              collectionBatch.insert(
                  CollectionsTable().tableName, _collection);

                collectionCount++;

            }
         }

         await scheduleBatch.commit(noResult: true);
         await collectionBatch.commit(noResult: true);


         context.read<LoginDataNotifier>().setMemberLoaded(memberCount);
       }

     }
     return {
       'memberInserted':memberCount,
       'investmentInserted':investmentCount,
       'scheduleInserted': scheduleCount,
       'collectionInserted': collectionCount
     };
  }

  static String _correctDateFormat(String date){
//    List<String> _dateSegments = date.split('-');
//    String newDate = _dateSegments.removeAt(2)+"-"+_getMonth(_dateSegments.removeAt(1))+"-"+_dateSegments.removeAt(0);
//    AppConfig.log(newDate,line:'147',className: 'MembeService');
    DateTime dt = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dt);
  }

  static String _getMonth(String initial){
    String month;
    switch(initial.toLowerCase()){
      case 'jan':
        month = '01';
        break;
      case 'feb':
        month = '02';
        break;
      case 'mar':
        month = '03';
        break;
      case 'apr':
        month = '04';
        break;
      case 'may':
        month = '05';
        break;
      case 'jun':
        month = '06';
        break;
      case 'jul':
        month = '07';
        break;
      case 'aug':
        month = '08';
        break;
      case 'sep':
        month = '09';
        break;
      case 'oct':
        month = '10';
        break;
      case 'nov':
        month = '11';
        break;
      case 'dec':
        month = '12';
        break;
    }
    return month;
  }
  
  static Future<int> getMembersCount() async{
    Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT count(*) as total from members");
    return (maps.length>0)? (maps.first)['total']:0;
  }
}