import 'package:nupms_app/persistance/interfaces/DDL.dart';

class TrainingInfosTable implements DDL{

  String _tableName = "training_infos";

  String get tableName{
    return this._tableName;
  }
  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "training_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "training_name VARCHAR(255)"
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