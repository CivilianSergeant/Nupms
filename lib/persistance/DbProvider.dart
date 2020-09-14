import 'package:nupms_app/config/AppConfig.dart';
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

  }

  void _createIndexes(Database db) {



  }

  Future<void> _dropTables(Database db) async{
    await db.execute(UsersTable().dropDDL()).then((_){
      AppConfig.log(UsersTable().tableName+" DROPPED");
    });

  }

  initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "gaccounts_app_storage.db");

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