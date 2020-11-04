import 'package:nupms_app/persistance/interfaces/DDL.dart';

class BusinessReasonsTable implements DDL{

  String _tableName = "business_reasons";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "business_reason_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "business_reason_name VARCHAR(255)"
        ")";
  }

  @override
  List<String> createIndexes() {
    //throw UnimplementedError();
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS ${tableName}";
  }

}