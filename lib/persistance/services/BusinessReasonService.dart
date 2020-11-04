import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/BusinessReason.dart';
import 'package:nupms_app/persistance/tables/BusinessReasonsTable.dart';
import 'package:sqflite/sqflite.dart';

class BusinessReasonService{

  static Future<int> truncate() async{
    Database db = await DbProvider.db.database;
    return await db.delete(BusinessReasonsTable().tableName);
  }

  static Future<int> addBusinessReasons(List<dynamic> businessReasons) async {

    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic businessReason in businessReasons){
      batch.insert(BusinessReasonsTable().tableName,BusinessReason(
          businessReasonId: businessReason['businessReasonId'],
          businessReasonName: businessReason['businessReasonName']
      ).toMap());

      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }
}