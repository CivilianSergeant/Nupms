class Collection {
  int id;
  int entrepreneurId;
  int newBusinessProposalId;
  int paybackId;
  int installmentNo;
  String collectionDate;
  double collectedAmount;
  int depositModeId;
  String receiptNo;
  int companyAccountId;
  String remark;
  bool isSynced;

  Collection({
    this.id,
    this.entrepreneurId,
    this.newBusinessProposalId,
    this.paybackId,
    this.installmentNo,
    this.collectionDate,
    this.collectedAmount,
    this.depositModeId,
    this.receiptNo,
    this.companyAccountId,
    this.remark,
    this.isSynced
  });

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'new_business_proposal_id':newBusinessProposalId,
      'entrepreneur_id': entrepreneurId,
      'payback_id': paybackId,
      'installment_no': installmentNo,
      'collection_date': collectionDate,
      'collected_amount': collectedAmount,
      'company_account_id': companyAccountId,
      'deposit_mode_id': depositModeId,
      'receipt_no':receiptNo,
      'remark':remark,
      'is_synced': (isSynced)? 1 : 0

    };
  }
}