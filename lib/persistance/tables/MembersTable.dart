import 'package:nupms_app/persistance/interfaces/DDL.dart';

class MembersTable implements DDL{

  String _tableName = "members";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "entrepreneur_id INTEGER,"
        "entrepreneur_code VARCHAR(100),"
        "entrepreneur_name VARCHAR(100),"
        "business_name VARCHAR(100),"
        "new_business_proposal_id INTEGER,"
        "approved_investment REAL,"
        "currency VARCHAR(5),"
        "investment_duration VARCHAR(120),"
        "total_investment REAL,"
        "phase_no INTEGER"
        ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_entrepreneur_code ON "+_tableName+"(entrepreneur_code);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_entrepreneur_id ON "+_tableName+"(entrepreneur_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_new_business_proposal_id ON "+_tableName+"(new_business_proposal_id);");
    return indexes;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS ${tableName}";
  }


}