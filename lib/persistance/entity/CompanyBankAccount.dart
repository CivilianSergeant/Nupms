class CompanyBankAccount{
  int id;
  int companyBankId;
  int depositModeId;
  String companyBankName;
  String companyBankBranchName;
  String accountName;
  String accountNo;

  CompanyBankAccount({this.id,this.companyBankId,
  this.depositModeId,this.companyBankName,
  this.companyBankBranchName,this.accountName,this.accountNo});

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'company_bank_id': companyBankId,
      'deposit_mode_id': depositModeId,
      'company_bank_name': companyBankName,
      'company_bank_branch_name': companyBankBranchName,
      'account_name': accountName,
      'account_no': accountNo
    };
  }


}