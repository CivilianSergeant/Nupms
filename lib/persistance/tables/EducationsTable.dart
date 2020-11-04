import 'package:nupms_app/persistance/interfaces/DDL.dart';

class EducationsTable implements DDL{

  String _tableName = "educations";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "education_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "education_name VARCHAR(255)"
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