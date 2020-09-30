import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupms_app/config/AppConfig.dart';

class DepositData with ChangeNotifier{
  List<Map<String,dynamic>> _depositModes = [];
  List<Map<String,dynamic>> _companyAccounts = [];
  List<Map<String,dynamic>> _depositBanks = [];
  List<Map<String,dynamic>> _depositBankBranches = [];
  List<Map<String,dynamic>> _depositables = [];
  List<Map<String,dynamic>> _deposits = [];
  String slipImgPath = null;

  String selectedDate = "";

  double _collectionAmmount = 0;
  double _depositAmmount = 0;

  int selectedMode;

  void setSlipImagePath(String filepath){
    this.slipImgPath = filepath;
    notifyListeners();
  }

  void setCollectionAmount(double d){
    this._collectionAmmount = d;
    notifyListeners();
  }

  double get CollectionAmount{
    return _collectionAmmount;
  }

  void setDepositAmount(double d){
    this._depositAmmount = d;
    notifyListeners();
  }

  double get DepositAmount{
    return _depositAmmount;
  }

  List<Map<String,dynamic>> get Depositables{
    return _depositables;
  }

  List<Map<String,dynamic>> get Deposits{
    return this._deposits;
  }

  void setDeposits(List<Map<String,dynamic>> deposits){
    this._deposits = deposits;
    notifyListeners();
  }

  void setDepositables(List<Map<String,dynamic>> depositables){
    double collectionAmount = 0;
    _depositables.clear();
    depositables.forEach((element) {
      if(element['collected_amount']<=0){
        return;
      }
      collectionAmount += element['collected_amount'];

      _depositables.add({
        'id':element['id'],
        'entrepreneur_name':element['entrepreneur_name'],
        'entrepreneur_code':element['entrepreneur_code'],
        'business_name':element['business_name'],
        'new_business_proposal_id':element['new_business_proposal_id'],
        'entrepreneur_id': element['entrepreneur_id'],
        'payback_id': element['payback_id'],
        'installment_no': element['installment_no'],
        'collected_amount':element['collected_amount'],
        'collection_date': element['collection_date'],
        'selected':false,
      });
    });
    setCollectionAmount(collectionAmount);
    notifyListeners();
  }

  List<Map<String,dynamic>> get DepositTypes{
    return this._depositModes;
  }

  List<Map<String,dynamic>> get DepositBanks{
    return this._depositBanks;
  }

  List<Map<String,dynamic>> get DepositBankBranches{
    return this._depositBankBranches;
  }

  List<Map<String,dynamic>> get CompanyBankAccounts{
    return this._companyAccounts;
  }

  void setDepositModes(List<Map<String,dynamic>> depositModes){
    this._depositModes = depositModes;
    notifyListeners();
  }

  void setCompanyAccounts(List<Map<String,dynamic>> companyAccounts){
    this._companyAccounts = companyAccounts;
    notifyListeners();
  }

  void setDepositBanks(List<Map<String,dynamic>> depositBanks){
    this._depositBanks = depositBanks;
    notifyListeners();
  }

  void setDepositBankBranches(List<Map<String,dynamic>> depositBankBranches){
    this._depositBankBranches = depositBankBranches;
    notifyListeners();
  }

  void updateUI(){
    notifyListeners();
  }

  void setDate(String d){
    AppConfig.log(d);
    this.selectedDate = d;
    notifyListeners();
  }

  String getDate(){
    AppConfig.log(selectedDate);
    return selectedDate;
  }
}