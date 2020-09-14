import 'package:nupms_app/persistance/entity/User.dart';
import 'package:nupms_app/persistance/repository/UserRepository.dart';
import 'package:nupms_app/services/network.dart';

class UserService extends NetworkService{
  UserRepository userRepo;

  UserService({
    this.userRepo
  });

  Future<User> checkCurrentUser() async {

//    User user = await find(imei);
//    return user;

    return User();
  }
}