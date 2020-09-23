import 'package:nupms_app/persistance/entity/CompanyBankAccount.dart';
import 'package:nupms_app/persistance/entity/DepositMode.dart';
import 'package:nupms_app/persistance/tables/CompanyBankAccountsTable.dart';
import 'package:nupms_app/persistance/tables/DepostModesTable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nupms_app/persistance/DbProvider.dart';

class CompanyBankAccountService {

  static Future<int> truncate() async{
    Database db = await DbProvider.db.database;
    return await db.delete(CompanyBankAccountsTable().tableName);
  }

  static Future<List<Map<String,dynamic>>> getCompanyBankAccounts(int depositModeId) async {
    Database db = await DbProvider.db.database;
    return db.query(CompanyBankAccountsTable().tableName,where: "deposit_mode_id=?", whereArgs: [depositModeId]);
  }

  static Future<int> addCompanyBankAccounts(List<dynamic> companyBankAccounts) async{
    Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    for(dynamic companyBankAccount in companyBankAccounts){
      batch.insert(CompanyBankAccountsTable().tableName,CompanyBankAccount(
          companyBankId: companyBankAccount['companyBankId'],
          depositModeId: companyBankAccount['depositModeId'],
          companyBankName: companyBankAccount['companyBankName'],
          companyBankBranchName: companyBankAccount['companyBankBranchName'],
          accountName: companyBankAccount['accountName'],
          accountNo: companyBankAccount['accountNo']
      ).toMap());

      i++;
    }

    await batch.commit(noResult: true);
    return i;
  }

}