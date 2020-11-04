import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/Village.dart';
import 'package:nupms_app/persistance/tables/VillagesTable.dart';
import 'package:sqflite/sqflite.dart';

class VillageService {

  static Future<int> truncate() async {
    Database db = await DbProvider.db.database;
    return await db.delete(VillagesTable().tableName);
  }

  static Future<int> addVillages(List<dynamic> villages) async {
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic village in villages){
      batch.insert(VillagesTable().tableName,Village(
          villageId: village['villageId'],
          villageName: village['villageName']
      ).toMap());

      i++;
    }

    await batch.commit(noResult: true);
    return i;
  }
}