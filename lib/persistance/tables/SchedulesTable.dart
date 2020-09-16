import 'package:nupms_app/persistance/interfaces/DDL.dart';

class SchedulesTable implements DDL{

  String _tableName = "schedules";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "entrepreneur_id INTEGER,"
        "installment_no INTEGER,"
        "payback_id INTEGER,"
        "payback_date VARCHAR(20),"
        "investment_pb REAL,"
        "otf REAL,"
        "total_paybackable REAL"
        ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_payback_id ON "+_tableName+"(payback_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_entrepreneur_id ON "+_tableName+"(entrepreneur_id);");
    return indexes;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS ${tableName}";
  }

}