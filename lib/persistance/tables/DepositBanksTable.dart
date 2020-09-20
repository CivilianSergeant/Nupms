import 'package:nupms_app/persistance/interfaces/DDL.dart';

class DepositBanksTable implements DDL{

  String _tableName = "deposit_banks";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "deposit_bank_id INTEGER,"
        "deposit_bank_name VARCHAR(100)"
    ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_deposit_bank_id ON "+_tableName+"(deposit_bank_id);");
    return indexes;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

}