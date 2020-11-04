import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/MaritalStatus.dart';
import 'package:nupms_app/persistance/tables/MaritalStatusTable.dart';
import 'package:sqflite/sqflite.dart';

class MaritalStatusService{

  static Future<int> truncate() async {
    Database db = await DbProvider.db.database;
    return await db.delete(MaritalStatusTable().tableName);
  }

  static Future<int> addMaritalStatus(List<dynamic> maritalStatus) async{
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic ms in maritalStatus){
      batch.insert(MaritalStatusTable().tableName,MaritalStatus(
          maritalStatusId: ms['maritalStatusId'],
          maritalStatusName: ms['maritalStatusName']
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }


}