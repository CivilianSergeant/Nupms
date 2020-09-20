import 'package:nupms_app/persistance/interfaces/DDL.dart';

class UsersTable implements DDL{

  String _tableName = "users";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
   return "CREATE TABLE "+_tableName+" ("
       "id INTEGER PRIMARY KEY AUTOINCREMENT,"
       "org_short_code VARCHAR(20),"
       "unit_id INTEGER,"
       "unit_name VARCHAR(50),"
       "area_id INTEGER,"
       "area_name VARCHAR(50),"
       "zone_id INTEGER,"
       "zone_name VARCHAR(100),"
       "employee_id INTEGER,"
       "employee_name VARCHAR(120),"
       "employee_code VARCHAR(100),"
       "download_master TINYINT(1) DEFAULT 0"
       ")";
  }

  @override
  List<String> createIndexes() {

  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

}