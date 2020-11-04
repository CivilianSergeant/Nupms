import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/Occupation.dart';
import 'package:nupms_app/persistance/tables/OccupationsTable.dart';
import 'package:sqflite/sqflite.dart';

class OccupationService{

  static Future<int> truncate() async {
    Database db = await DbProvider.db.database;
    return await db.delete(OccupationsTable().tableName);
  }

  static Future<int> addOccupations(List<dynamic> occupations) async{
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic occupation in occupations){
      batch.insert(OccupationsTable().tableName,Occupation(
          occupationId: occupation['occupationId'],
          occupationName: occupation['occupationName']
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }
}