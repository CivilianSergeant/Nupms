import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/persistance/tables/CollectionsTable.dart';
import 'package:nupms_app/persistance/tables/CompanyBankAccountsTable.dart';
import 'package:nupms_app/persistance/tables/DepositBankBranchesTable.dart';
import 'package:nupms_app/persistance/tables/DepositBanksTable.dart';
import 'package:nupms_app/persistance/tables/DepostModesTable.dart';
import 'package:nupms_app/persistance/tables/InvestmentsTable.dart';
import 'package:nupms_app/persistance/tables/MembersTable.dart';
import 'package:nupms_app/persistance/tables/SchedulesTable.dart';
import 'package:nupms_app/persistance/tables/UsersTable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider{
  DbProvider._();
  static final DbProvider db = DbProvider._();
  static Database _database;
  static int _dbVersion=1;

  Future<Database> get database async {
    if (_database != null){
      return _database;
    }


    _database = await initDB();
    return _database;
  }

  Future<void> _createTables(Database db) async{
    await db.execute(UsersTable().createDDL()).then((_){
      AppConfig.log(UsersTable().tableName+" Created");
    });
    await db.execute(MembersTable().createDDL()).then((_){
      AppConfig.log(MembersTable().tableName+" Created");
    });
    await db.execute(InvestmentsTable().createDDL()).then((_){
      AppConfig.log(InvestmentsTable().tableName+" Created");
    });
    await db.execute(SchedulesTable().createDDL()).then((_){
      AppConfig.log(SchedulesTable().tableName+" Created");
    });
    await db.execute(CollectionsTable().createDDL()).then((_){
      AppConfig.log(CollectionsTable().tableName+" Created");
    });
    await db.execute(DepositModesTable().createDDL()).then((_){
      AppConfig.log(DepositModesTable().tableName+" Created");
    });
    await db.execute(CompanyBankAccountsTable().createDDL()).then((_){
      AppConfig.log(CompanyBankAccountsTable().tableName+" Created");
    });
    await db.execute(DepositBanksTable().createDDL()).then((_){
      AppConfig.log(DepositBanksTable().tableName+" Created");
    });
    await db.execute(DepositBankBranchesTable().createDDL()).then((_){
      AppConfig.log(DepositBankBranchesTable().tableName+" Created");
    });

  }

  void _createIndexes(Database db) {
    List<String> memberIndexes = MembersTable().createIndexes();
    memberIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> scheduleIndexes = SchedulesTable().createIndexes();
    scheduleIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> collectionIndexes = CollectionsTable().createIndexes();
    collectionIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> depositModeIndexes = DepositModesTable().createIndexes();
    depositModeIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });
    List<String> companyBankAccIndexes = CompanyBankAccountsTable().createIndexes();
    companyBankAccIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });
    List<String> depositBankIndexes = DepositBanksTable().createIndexes();
    depositBankIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });
    List<String> depositBankBranchesIndexes = DepositBankBranchesTable().createIndexes();
    depositBankBranchesIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });
  }

  Future<void> _dropTables(Database db) async{
    await db.execute(UsersTable().dropDDL()).then((_){
      AppConfig.log(UsersTable().tableName+" DROPPED");
    });

    await db.execute(MembersTable().dropDDL()).then((_){
      AppConfig.log(MembersTable().tableName+" DROPPED");
    });

    await db.execute(InvestmentsTable().dropDDL()).then((_){
      AppConfig.log(InvestmentsTable().tableName+" DROPPED");
    });

    await db.execute(SchedulesTable().dropDDL()).then((_){
      AppConfig.log(SchedulesTable().tableName+" DROPPED");
    });

    await db.execute(CollectionsTable().dropDDL()).then((_){
      AppConfig.log(CollectionsTable().tableName+" DROPPED");
    });

    await db.execute(DepositModesTable().dropDDL()).then((_){
      AppConfig.log(DepositModesTable().tableName+" DROPPED");
    });

    await db.execute(CompanyBankAccountsTable().dropDDL()).then((_){
      AppConfig.log(CompanyBankAccountsTable().tableName+" DROPPED");
    });

    await db.execute(DepositBanksTable().dropDDL()).then((_){
      AppConfig.log(DepositBanksTable().tableName+" DROPPED");
    });

    await db.execute(DepositBankBranchesTable().dropDDL()).then((_){
      AppConfig.log(DepositBankBranchesTable().tableName+" DROPPED");
    });

  }

  initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "nupms_app_storage.db");

    return await openDatabase(path,version: _dbVersion,
        onOpen: (db) {

        },
        onCreate: (Database db, int version) async {
            this._createTables(db).then((_) {
              this._createIndexes(db);
            });
        },
        onUpgrade: (Database db, int oldVersion , int newVersion) async{
          this._dropTables(db).then((_){
            this._createTables(db);
          });
        }
    );
  }

}