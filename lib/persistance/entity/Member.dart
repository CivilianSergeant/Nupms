class Member{
  int entrepreneurId;
  int newBusinessProposalId;
  String entrepreneurCode;
  String entrepreneurName;
  String businessName;
  double approvedInvestment;
  String currency;
  String investmentDuration;
  double totalInvestment;

  Member({
    this.entrepreneurId,
    this.newBusinessProposalId,
    this.entrepreneurCode,
    this.entrepreneurName,
    this.businessName,
    this.approvedInvestment,
    this.currency,
    this.investmentDuration,
    this.totalInvestment
  });


  Map<String,dynamic> toMap(){
    return {
      'entrepreneur_id': entrepreneurId,
      'entrepreneur_code': entrepreneurCode,
      'entrepreneur_name': entrepreneurName,
      'business_name': businessName,
      'new_business_proposal_id': newBusinessProposalId,
      'approved_investment':approvedInvestment,
      'currency': currency,
      'investment_duration': investmentDuration,
      'total_investment': totalInvestment
    };
  }
}