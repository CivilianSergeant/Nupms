import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/Thana.dart';
import 'package:nupms_app/persistance/tables/ThanasTable.dart';
import 'package:sqflite/sqflite.dart';

class ThanaService {

  static Future<int> truncate() async {
    Database db = await DbProvider.db.database;
    return await db.delete(ThanasTable().tableName);
  }

  static Future<int> addThanas(List<dynamic> thanas) async {
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic thana in thanas){
      batch.insert(ThanasTable().tableName,Thana(
          thanaId: thana['thanaId'],
          thanaName: thana['thanaName']
      ).toMap());
      i++;
    }

    await batch.commit(noResult: true);
    return i;
  }

}