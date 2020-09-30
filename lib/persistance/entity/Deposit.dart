class Deposit{

  int id;
  int depositSlipSl;
  String collectionTransferDate;
  String depositSlipNumber;
  int depositModeId;
  int depositBankId;
  int depositBankBranchId;
  String depositSendingType;
  int companyBankAccountId;
  double depositAmount;
  String depositSlipImage;
  String upToDate;

  Deposit({
    this.id,
    this.depositSlipSl,
    this.depositSlipNumber,
    this.collectionTransferDate,
    this.companyBankAccountId,
    this.depositBankId,
    this.depositModeId,
    this.depositBankBranchId,
    this.depositSendingType,
    this.depositAmount,
    this.depositSlipImage,
    this.upToDate
  });


  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'collection_transfer_date':collectionTransferDate,
      'deposit_slip_sl':depositSlipSl,
      'deposit_slip_number':depositSlipNumber,
      'deposit_mode_id':depositModeId,
      'deposit_bank_id':depositBankId,
      'deposit_bank_branch_id':depositBankBranchId,
      'company_bank_account_id':companyBankAccountId,
      'deposit_sending_type':depositSendingType,
      'deposit_amount':depositAmount,
      'deposit_slip_image':depositSlipImage,
      'up_to_date':upToDate
    };
  }
}