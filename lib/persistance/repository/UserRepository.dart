import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/User.dart';
import 'package:nupms_app/persistance/interfaces/Repository.dart';
import 'package:nupms_app/persistance/repository/BaseRepository.dart';
import 'package:nupms_app/persistance/tables/UsersTable.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository extends BaseRepository{

  Repository _profile;

  UserRepository({Repository profileRepo}):super(UsersTable().tableName){
    this._profile = profileRepo;
  }

  @override
  Future<User> findById(int id) async{
    dynamic map = super.findById(id);
    return (map !=null)? User.fromJSON(map) : null;
  }

//  Future<Map<String,dynamic>> getProfile(int id) async{
//    Database db = await getDBInstance();
//    List<Map<String,dynamic>> maps = await db.query(ProfilesTable().tableName,where: "profile_id=?",whereArgs: [id]);
//    return (maps.length>0)? maps.first : null;
//  }

  @override
  find({String where, List<dynamic> whereArgs,bool firstOnly})  async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.query(tableName,where: where, whereArgs: whereArgs);

    return (firstOnly != null && firstOnly == true)?
        ((maps.length>0)? User.fromJSON(maps.first) : null ) : maps;
  }

  @override
  Future<int> save(dynamic obj) async{

    User user = obj['user'];
    user.downloadMaster=false;
    int userInserted = await super.save(user);
    return userInserted;
  }

  Future<int> updateUserVerification(String vid, String uid, int id) async{
    final Database db = await DbProvider.db.database;
    return db.update(tableName, {"verified_id":vid,"user_id":uid,"is_verified":1},where: "sync_id=?",whereArgs: [id]);
  }

//  Future<int> updateBusinessType(User user) async{
//    final Database db = await DbProvider.db.database;
//    return db.update(tableName, {"business_type_id":user.businessTypeId},where:"id=?",whereArgs: [user.id],conflictAlgorithm:
//    ConflictAlgorithm.replace);
//  }

  Future<int> updateDownloadMasterFlag(User user) async{
    final Database db = await DbProvider.db.database;
    int downLoadVoucher = (user.downloadMaster)? 1:0;
    return db.update(tableName, {"download_master":downLoadVoucher},where:"id=?",whereArgs: [user.id],conflictAlgorithm:
    ConflictAlgorithm.replace);
  }


}