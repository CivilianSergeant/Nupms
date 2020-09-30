import 'package:nupms_app/persistance/interfaces/DDL.dart';

class CollectionsTable implements DDL{

  String _tableName = "collections";

  String get tableName{
    return this._tableName;
  }


  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "new_business_proposal_id INTEGER,"
        "entrepreneur_id INTEGER,"
        "payback_id INTEGER,"
        "installment_no INTEGER,"
        "collected_amount REAL,"
        "receipt_no VARCHAR(50),"
        "deposit_mode_id INTEGER,"
        "dd_cheque VARCHAR(50),"
        "banking_type VARCHAR(10),"
        "company_account_id INTEGER,"
        "remark VARCHAR(100),"
        "collection_date VARCHAR(20),"
        "is_synced TINYINT(1),"
        "is_deposited TINYINT(1),"
        "in_transit TINYINT(1),"
        "deposit_id INTEGER DEFAULT NULL"
        ")";
  }

  @override
  List<String> createIndexes() {

    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_payback_id ON "+_tableName+"(payback_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_entrepreneur_id ON "+_tableName+"(entrepreneur_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_new_business_proposal_id ON "+_tableName+"(new_business_proposal_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_deposit_mode_id ON "+_tableName+"(deposit_mode_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_company_account_id ON "+_tableName+"(company_account_id);");
    return indexes;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS ${tableName}";
  }

}