class DepositBankBranch{
  int id;
  int depositBankId;
  int depositBankBranchId;
  String depositBankBranchName;

  DepositBankBranch({
    this.id,
    this.depositBankId,
    this.depositBankBranchId,
    this.depositBankBranchName
  });

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'deposit_bank_id': depositBankId,
      'deposit_bank_branch_id': depositBankBranchId,
      'deposit_bank_branch_name': depositBankBranchName
    };
  }
}