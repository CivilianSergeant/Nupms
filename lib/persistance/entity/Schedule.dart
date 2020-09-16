class Schedule{
  int id;
  int entrepreneurId;
  int installmentNo;
  int paybackId;
  String paybackDate;
  double investmentPB;
  double otf;
  double totalPaybackAble;

  Schedule({
    this.id,
    this.entrepreneurId,
    this.installmentNo,
    this.paybackId,
    this.paybackDate,
    this.investmentPB,
    this.otf,
    this.totalPaybackAble
  });

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'entrepreneur_id':entrepreneurId,
      'installment_no':installmentNo,
      'payback_id': paybackId,
      'payback_date': paybackDate,
      'investment_pb': investmentPB,
      'otf': otf,
      'total_paybackable': totalPaybackAble
    };
  }

}