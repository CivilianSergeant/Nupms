import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/OccupationDuration.dart';
import 'package:nupms_app/persistance/tables/OccupationDurationsTable.dart';
import 'package:sqflite/sqflite.dart';

class OccupationDurationService {

  static Future<int> truncate() async {
    Database db = await DbProvider.db.database;
    return await db.delete(OccupationDurationsTable().tableName);
  }

  static Future<int> addOccupationDurations(List<dynamic> occupationDurations) async{
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic occupationDuration in occupationDurations){
      batch.insert(OccupationDurationsTable().tableName,OccupationDuration(
          occupationDurationId: occupationDuration['occupationDurationId'],
          occupationDurationName: occupationDuration['occupationDurationName']
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }
}