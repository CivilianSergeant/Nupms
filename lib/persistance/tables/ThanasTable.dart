import 'package:nupms_app/persistance/interfaces/DDL.dart';

class ThanasTable implements DDL{

  String _tableName = "thanas";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "thana_id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "thana_name VARCHAR(255)"
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