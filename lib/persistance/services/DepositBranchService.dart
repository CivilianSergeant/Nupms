import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/DepositBankBranch.dart';
import 'package:nupms_app/persistance/tables/DepositBankBranchesTable.dart';
import 'package:sqflite/sqflite.dart';

class DepositBranchService{

  static Future<void> truncate() async {
    Database db = await DbProvider.db.database;
    db.delete(DepositBankBranchesTable().tableName);
  }

  static Future<List<Map<String,dynamic>>> getBranches(int id) async {
    Database db = await DbProvider.db.database;
    return db.query(DepositBankBranchesTable().tableName,where: "deposit_bank_id=?",whereArgs: [id]);
  }

  static Future<int> addDepositBank(List<dynamic> banks) async {
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    banks.forEach((element) {
      batch.insert(DepositBankBranchesTable().tableName, DepositBankBranch(
          depositBankId: element['depositBankId'],
          depositBankBranchId: element['depositBankBranchID'],
          depositBankBranchName: element['depositBankBranchName']
      ).toMap());
      i++;
    });
    await batch.commit(noResult: true);
    return i;
  }
}