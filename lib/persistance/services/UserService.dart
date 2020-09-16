import 'package:nupms_app/persistance/entity/User.dart';
import 'package:nupms_app/persistance/repository/UserRepository.dart';
import 'package:nupms_app/services/network.dart';

class UserService extends NetworkService{
  UserRepository userRepo;

  UserService({
    this.userRepo
  });

  Future<User> checkCurrentUser() async {

    User user = await userRepo.find(firstOnly: true);
    return user;

  }

  Future<int> saveUser(User user) async {
    return await userRepo.save(user.toMap());
  }
  Future<void> removeUsers() async{
    await userRepo.truncate();
  }


}