import 'package:nupms_app/persistance/interfaces/DDL.dart';

class DepositsTable implements DDL{

  String _tableName = "deposits";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "deposit_slip_sl INTEGER,"
        "up_to_date VARCHAR(50),"
        "collection_transfer_date VARCHAR(50),"
        "deposit_slip_number VARCHAR(20),"
        "deposit_mode_id INTEGER,"
        "deposit_bank_id INTEGER,"
        "deposit_bank_branch_id INTEGER,"
        "deposit_sending_type VARCHAR(20),"
        "company_bank_account_id INTEGER,"
        "deposit_amount REAL,"
        "deposit_slip_image VARCHAR(255) DEFAULT NULL"
        ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_deposit_mode_id ON "+_tableName+"(deposit_mode_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_deposit_bank_id ON "+_tableName+"(deposit_bank_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_deposit_bank_branch_id ON "+_tableName+"(deposit_bank_branch_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_company_bank_account_id ON "+_tableName+"(company_bank_account_id);");
    return indexes;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS ${tableName}";
  }

}