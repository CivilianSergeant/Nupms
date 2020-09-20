class DepositBank{
  int id;
  int depositBankId;
  String depositBankName;

  DepositBank({
    this.id,
    this.depositBankId,
    this.depositBankName
  });

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'deposit_bank_id': depositBankId,
      'deposit_bank_name': depositBankName
    };
  }
}