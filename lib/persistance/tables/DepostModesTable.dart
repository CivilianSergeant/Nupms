import 'package:nupms_app/persistance/interfaces/DDL.dart';

class DepositModesTable implements DDL{

  String _tableName = "deposit_modes";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "deposit_mode_id INTEGER,"
        "deposit_mode_name VARCHAR(20),"
        "deposit_mode_type VARCHAR(5),"
        "banking_type VARCHAR(10)"
        ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_deposit_mode_id ON "+_tableName+"(deposit_mode_id);");
    return indexes;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

}