import 'package:flutter/cupertino.dart';

class Payback{

  int paybackId;
  int entrepreneurId;
  int newBusinessProposalId;
  int Id;
  int installmentNo;
  double remaining;
  double totalPayback;
  String date;
  double collected;
  String paybackDate;
  bool bankingType;
  TextEditingController collectionDate;
  TextEditingController receiptNo;
  int type;
  double investmentPB;
  double otf;
  TextEditingController ddCheque;
  int companyAccountId;
  TextEditingController collectionAmount;
  TextEditingController remark;
  int selectedType;
  bool isDue;
  DateTime fromInitial;
  int fromStartYear;
  int fromEndYear;

  Payback({this.installmentNo,this.remaining, this.collectionDate,
    this.collected,this.totalPayback,this.paybackDate,this.isDue,
    this.receiptNo,this.collectionAmount,this.entrepreneurId,
    this.newBusinessProposalId,this.remark,this.paybackId,
    this.ddCheque,this.fromEndYear,this.fromStartYear,this.fromInitial,
    this.investmentPB,this.otf,this.bankingType
  });

  Map<String,dynamic> toMap(){
    return {
      'payback_id': paybackId,
      'collection_date':collectionDate.text,
      'collection_amount': collectionAmount.text,
      'dd_check': ddCheque.text,
      'remark':remark.text,
      'receipt_no':receiptNo.text,
      'selected_mode':selectedType,
      'entrepreneur_id': entrepreneurId,
      'new_business_proposal_id': newBusinessProposalId,
      'company_bank_id': companyAccountId,
    };
  }

}