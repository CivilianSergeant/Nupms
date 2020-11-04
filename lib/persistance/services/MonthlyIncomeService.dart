import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/MonthlyIncome.dart';
import 'package:nupms_app/persistance/tables/MonthlyIncomesTable.dart';
import 'package:sqflite/sqflite.dart';

class MonthlyIncomeService{

  static Future<int> truncate() async {
    Database db = await DbProvider.db.database;
    return await db.delete(MonthlyIncomesTable().tableName);
  }

  static Future<int> addMonthlyIncomes(List<dynamic> monthlyIncomes) async {
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic monthlyIncome in monthlyIncomes){
      batch.insert(MonthlyIncomesTable().tableName,MonthlyIncome(
          monthlyIncome: monthlyIncome['monthlyIncome']
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }
}