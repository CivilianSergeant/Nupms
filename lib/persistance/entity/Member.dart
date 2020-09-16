class Member{
  int id;
  int entrepreneurId;
  int newBusinessProposalId;
  String entrepreneurCode;
  String entrepreneurName;
  String businessName;
  double approvedInvestment;
  String currency;
  String investmentDuration;
  double totalInvestment;
  int phaseNo;

  Member({
    this.id,
    this.entrepreneurId,
    this.newBusinessProposalId,
    this.entrepreneurCode,
    this.entrepreneurName,
    this.businessName,
    this.approvedInvestment,
    this.currency,
    this.investmentDuration,
    this.totalInvestment,
    this.phaseNo
  });


  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'entrepreneur_id': entrepreneurId,
      'entrepreneur_code': entrepreneurCode,
      'entrepreneur_name': entrepreneurName,
      'business_name': businessName,
      'new_business_proposal_id': newBusinessProposalId,
      'approved_investment':approvedInvestment,
      'currency': currency,
      'investment_duration': investmentDuration,
      'total_investment': totalInvestment,
      'phase_no':phaseNo
    };
  }
}