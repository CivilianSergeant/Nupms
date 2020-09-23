import 'package:nupms_app/persistance/entity/DepositMode.dart';
import 'package:nupms_app/persistance/tables/DepostModesTable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nupms_app/persistance/DbProvider.dart';

class DepositModeService {

  static Future<int> truncate() async{
    Database db = await DbProvider.db.database;
    return await db.delete(DepositModesTable().tableName);
  }

  static Future<List<Map<String,dynamic>>> getModes() async {
    Database db = await DbProvider.db.database;
    return db.query(DepositModesTable().tableName);
  }

  static Future<int> addDepositModes(List<dynamic> depositModes) async{
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic depositMode in depositModes){
      batch.insert(DepositModesTable().tableName,DepositMode(
        depositModeId: depositMode['depositModeId'],
        depositModeName: depositMode['depositModeName'],
        depositModeType: depositMode['depositModeType'],
        bankingType: depositMode['bankingType']
      ).toMap());

      i++;
    }

    await batch.commit(noResult: true);
    return i;
  }

}