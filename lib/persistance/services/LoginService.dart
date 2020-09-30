import 'package:flutter/material.dart';
import 'package:nupms_app/config/ApiUrl.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/LoginDataNotifier.dart';
import 'package:nupms_app/model/ServiceResponse.dart';
import 'package:nupms_app/persistance/entity/User.dart';
import 'file:///C:/Users/ASUS/IdeaProjects/nupms_app/lib/persistance/services/MemberService.dart';
import 'package:nupms_app/persistance/repository/UserRepository.dart';
import 'package:nupms_app/persistance/services/CompanyBankAccountService.dart';
import 'package:nupms_app/persistance/services/DepositBankService.dart';
import 'package:nupms_app/persistance/services/DepositBranchService.dart';
import 'package:nupms_app/persistance/services/DepositModeService.dart';
import 'package:nupms_app/persistance/services/DepositService.dart';
import 'package:nupms_app/persistance/services/UserService.dart';
import 'package:nupms_app/services/network.dart';
import 'package:provider/provider.dart';

class LoginService with NetworkService{

  Future<ServiceResponse> authenticate({
    BuildContext context,
    String username,
    String mobileNo,
    String password
  }) async{
    if(!await checkNetwork()){
      return ServiceResponse(status: 500, message: "Sorry! Internet not available");
    }

    setUrl(getApiUrl('login'));
    Map<String,dynamic> data = {
      'username': username,
      'password': password,
      'mobileNo': mobileNo, //'01719545357',
      'projectStatus': (AppConfig.getEnv() == Env.Dev)? 'Test': 'Live'
    };
    Map<String,String> header = {
      'Content-Type': 'application/json'
    };
    Map<String,dynamic> result = await post(data,header: header);
    if(result['status']!=200){
      return ServiceResponse(
          status: 500,
          message: result['message']
      );
    }

    UserService userService = UserService(userRepo: UserRepository());
    User currentUser = await userService.checkCurrentUser();
    AppConfig.log(currentUser);

    if(currentUser!=null){
      // truncate all entities
      await userService.removeUsers();
      await MemberService.removeMembers();
      await DepositModeService.truncate();
      await CompanyBankAccountService.truncate();
      await DepositBankService.truncate();
      await DepositBranchService.truncate();
      await DepositService.truncate();

    }

    User user = User.fromJSON(result['common']);
    user.orgShortCode = result['orgShortCode'];
    AppConfig.log((user.toMap()),line:'54',className: 'LoginService');
//    return ServiceResponse(status:500,message:result['message']);
    int userId = await userService.saveUser(user);

    if(userId > 0){

      // Add Deposit Modes
      int depositModeInserted = await DepositModeService.addDepositModes(result['depositModes']);
      AppConfig.log("No of Deposit Mode: ${depositModeInserted}");


      // Add CompanyBankAccounts
      int companyBankAccountInserted = await CompanyBankAccountService.addCompanyBankAccounts(result['companyBankAccounts']);
      AppConfig.log("No of CompanyBankAccount: ${companyBankAccountInserted}");

      // Add Deposit Banks
      int depositBankInserted = await DepositBankService.addDepositBank(result['depositBanks']);
      AppConfig.log("No of DepositBank: ${depositModeInserted}");
      
      // Add Deposit Bank Branch
      int depositBankBranchInserted = await DepositBranchService.addDepositBank(result['depositBankBranchs']);
      AppConfig.log("No of DepositBankBranch: ${depositModeInserted}");

      // Add Entrepreneurs

      List<dynamic> entrepreneurs = result['entrepreneurs'];
      context.read<LoginDataNotifier>().setMemberCount(entrepreneurs.length);
      Map<String,dynamic> inserted = await MemberService.addMembers(context,entrepreneurs);
      AppConfig.log(inserted,line: "65");

      // Add User to AppData
      user.id = userId;
      context.read<AppData>().setUser(user);
      if(inserted['memberInserted']>0){
        return ServiceResponse(status:200);
      }


    }


  }
}