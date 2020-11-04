import 'package:nupms_app/persistance/interfaces/DDL.dart';

class MaritalStatusTable implements DDL{

  String _tableName = "marital_status";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "marital_status_id VARCHAR(5),"
        "marital_status_name VARCHAR(255)"
        ")";
  }

  @override
  List<String> createIndexes() {
    // TODO: implement createIndexes
//    throw UnimplementedError();
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS ${tableName}";
  }

}