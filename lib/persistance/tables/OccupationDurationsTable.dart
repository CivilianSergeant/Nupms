import 'package:nupms_app/persistance/interfaces/DDL.dart';

class OccupationDurationsTable implements DDL {

  String _tableName = "occupation_durations";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "occupation_duration_id VARCHAR(11),"
        "occupation_duration_name VARCHAR(255)"
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