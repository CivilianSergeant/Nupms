import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/Union.dart';
import 'package:nupms_app/persistance/tables/UnionsTable.dart';
import 'package:sqflite/sqflite.dart';

class UnionService{

  static Future<int> truncate() async {
    Database db = await DbProvider.db.database;
    return await db.delete(UnionsTable().tableName);
  }

  static Future<int> addUnions(List<dynamic> unions) async {
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic unions in unions){
      batch.insert(UnionsTable().tableName,Union(
          unionId: unions['unionId'],
          unionName: unions['unionName']
      ).toMap());
      i++;
    }

    await batch.commit(noResult: true);
    return i;
  }
}