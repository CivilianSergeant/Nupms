import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/Deposit.dart';
import 'package:nupms_app/persistance/tables/DepositsTable.dart';
import 'package:sqflite/sqflite.dart';

class DepositService{

  static Future<void> truncate() async{
    Database db = await DbProvider.db.database;
    return await db.delete(DepositsTable().tableName);
  }

  static Future<int> saveDeposit(Deposit deposit) async{
    AppConfig.log(deposit.toMap(),line: '15',className: 'DepositService');
    Database db = await DbProvider.db.database;
    return await db.insert(DepositsTable().tableName, deposit.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String,dynamic>>> getDeposits() async {
    Database db = await DbProvider.db.database;
    return db.query(DepositsTable().tableName);
  }

  static Future<List<Map<String,dynamic>>> getDepositables(String date) async{
    Database db = await DbProvider.db.database;
    String sql = "SELECT m.entrepreneur_name,m.entrepreneur_code,m.business_name,c.* FROM collections c join members m"
        " ON m.entrepreneur_id = c.entrepreneur_id"
        " WHERE c.is_deposited=0 and strftime('%s',collection_date) <= strftime('%s','${(date != null)? 'now': date}')";
    return await db.rawQuery(sql);
  }
}