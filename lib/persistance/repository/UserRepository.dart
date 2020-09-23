import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/User.dart';
import 'package:nupms_app/persistance/interfaces/Repository.dart';
import 'package:nupms_app/persistance/repository/BaseRepository.dart';
import 'package:nupms_app/persistance/tables/UsersTable.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository extends BaseRepository{

  UserRepository({Repository profileRepo}):super(UsersTable().tableName);

  @override
  Future<User> findById(int id) async{
    dynamic map = super.findById(id);
    return (map !=null)? User.fromJSON(map) : null;
  }

  @override
  find({String where, List<dynamic> whereArgs,bool firstOnly})  async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.query(tableName,where: where, whereArgs: whereArgs);
    AppConfig.log(maps);
    return (firstOnly != null && firstOnly == true)?
        ((maps.length>0)? User.fromMap(maps.first) : null ) : maps;
  }

  @override
  Future<int> save(dynamic obj) async{

    User user = User(
      unitId: obj['unit_id'],
      orgShortCode: obj['org_short_code'],
      unitName: obj['unit_name'],
      areaId: obj['area_id'],
      areaName: obj['area_name'],
      zoneId: obj['zone_id'],
      zoneName: obj['zone_name'],
      employeeId: obj['employee_id'],
      employeeCode: obj['employee_code'],
      employeeName: obj['employee_name'],
      downloadMaster: false
    );
    AppConfig.log(user.toMap(),line:'32',className:'UserRepo');
    int userInserted = await super.save(user);
    return userInserted;
  }

  Future<int> updateUserVerification(String vid, String uid, int id) async{
    final Database db = await DbProvider.db.database;
    return db.update(tableName, {"verified_id":vid,"user_id":uid,"is_verified":1},where: "sync_id=?",whereArgs: [id]);
  }


  Future<int> updateDownloadMasterFlag(User user) async{
    final Database db = await DbProvider.db.database;
    int downLoadMaster = (user.downloadMaster)? 1:0;
    return db.update(tableName, {"download_master":downLoadMaster},where:"id=?",whereArgs: [user.id],conflictAlgorithm:
    ConflictAlgorithm.replace);
  }


}