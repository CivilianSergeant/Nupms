class DepositBank{
  int depositBankId;
  String depositBankName;

  DepositBank({
    this.depositBankId,
    this.depositBankName
  });

  Map<String,dynamic> toMap(){
    return {
      'deposit_bank_id': depositBankId,
      'deposit_bank_name': depositBankName
    };
  }
}