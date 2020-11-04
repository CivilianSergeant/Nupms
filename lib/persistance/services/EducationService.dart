import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/Education.dart';
import 'package:nupms_app/persistance/tables/EducationsTable.dart';
import 'package:sqflite/sqflite.dart';

class EducationService{

  static Future<int> truncate() async{
    Database db = await DbProvider.db.database;
    return await db.delete(EducationsTable().tableName);
  }

  static Future<int> addEducations(List<dynamic> educations) async {
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic education in educations){
      batch.insert(EducationsTable().tableName,Education(
          educationId: education['educationId'],
          educationName: education['educationName']
      ).toMap());

      i++;
    }
    await batch.commit(noResult: true);
    return i;

  }
}