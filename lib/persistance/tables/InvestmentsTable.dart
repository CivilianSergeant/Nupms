import 'package:nupms_app/persistance/interfaces/DDL.dart';

class InvestmentsTable implements DDL{

  String _tableName = "investments";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "entrepreneur_id INTEGER,"
        "new_business_proposal_id INTEGER,"
        "cheque_no VARCHAR(100),"
        "amount REAL,"
        "remaining_amount REAL,"
        "accumulated REAL,"
        "placement_date VARCHAR(20)"
        ")";
  }

  @override
  List<String> createIndexes() {
    // TODO: implement createIndexes
    throw UnimplementedError();
  }

  @override
  String dropDDL() {
    // TODO: implement dropDDL
    return "DROP TABLE IF EXISTS ${tableName}";
  }

}