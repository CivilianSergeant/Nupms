import 'package:nupms_app/persistance/interfaces/DDL.dart';

class VillagesTable implements DDL {

  String _tableName = "villages";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "village_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "village_name VARCHAR(255)"
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