import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/DepositBank.dart';
import 'package:nupms_app/persistance/tables/DepositBanksTable.dart';
import 'package:sqflite/sqflite.dart';

class DepositBankService{

  static Future<void> truncate() async {
    Database db = await DbProvider.db.database;
    db.delete(DepositBanksTable().tableName);
  }

  static Future<List<Map<String,dynamic>>> getBanks() async {
    Database db = await DbProvider.db.database;
    return db.query(DepositBanksTable().tableName);
  }

  static Future<int> addDepositBank(List<dynamic> banks) async {
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    banks.forEach((element) {
      batch.insert(DepositBanksTable().tableName, DepositBank(
        depositBankId: element['depositBankId'],
        depositBankName: element['depositBankName']
      ).toMap());
      i++;
    });
    await batch.commit(noResult: true);
    return i;
  }
}