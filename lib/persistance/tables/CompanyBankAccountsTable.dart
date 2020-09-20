import 'package:nupms_app/persistance/interfaces/DDL.dart';

class CompanyBankAccountsTable implements DDL{

  String _tableName = "company_bank_accounts";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "company_bank_id INTEGER,"
      "deposit_mode_id INTEGER,"
      "company_bank_name VARCHAR(100),"
      "company_bank_branch_name VARCHAR(100),"
      "account_name VARCHAR(100),"
      "account_no VARCHAR(50)"
    ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_company_bank_id ON "+_tableName+"(company_bank_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_deposit_mode_id ON "+_tableName+"(deposit_mode_id);");
    return indexes;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

}