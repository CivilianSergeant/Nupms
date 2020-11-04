import 'package:nupms_app/persistance/interfaces/DDL.dart';

class OccupationsTable implements DDL{

  String _tableName = "occupations";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "occupation_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "occupation_name VARCHAR(255)"
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