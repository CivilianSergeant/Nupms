import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/TrainingInfo.dart';
import 'package:nupms_app/persistance/tables/TrainingInfosTable.dart';
import 'package:sqflite/sqflite.dart';

class TrainingInfoService{

  static Future<int> truncate() async{
    Database db = await DbProvider.db.database;
    return await db.delete(TrainingInfosTable().tableName);
  }

  static Future<int> addTrainingInfo(List<dynamic> trainingInfos) async{
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic trainingInfo in trainingInfos){
      batch.insert(TrainingInfosTable().tableName,TrainingInfo(
          trainingId: trainingInfo['trainingId'],
          trainingName: trainingInfo['trainingName']
      ).toMap());

      i++;
    }

    await batch.commit(noResult: true);
    return i;
  }
}