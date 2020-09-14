class CompanyBankAccount{
  int companyBankId;
  int depositModeId;
  String companyBankName;

  CompanyBankAccount({this.companyBankId,
  this.depositModeId,this.companyBankName});

  Map<String,dynamic> toMap(){
    return {
      'company_bank_id': companyBankId,
      'deposit_mode_id': depositModeId,
      'company_bank_name': companyBankName
    };
  }


}