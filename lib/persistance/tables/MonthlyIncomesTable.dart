import 'package:nupms_app/persistance/interfaces/DDL.dart';

class MonthlyIncomesTable implements DDL{

  String _tableName = "monthly_incomes";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "monthly_income VARCHAR(255)"
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