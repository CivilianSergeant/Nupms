class Investment{
  int id;
  int newBusinessProposalId;
  String chequeNo;
  double amount;
  double remainingAmount;
  double accumulated;
  String placementDate;


  Investment({
    this.id,
    this.newBusinessProposalId,
    this.chequeNo,
    this.amount,
    this.remainingAmount,
    this.accumulated,
    this.placementDate
  });

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'new_business_proposal_id': newBusinessProposalId,
      'cheque_no': chequeNo,
      'amount': amount,
      'remaining_amount': remainingAmount,
      'accumulated': accumulated,
      'placement_date':placementDate
    };
  }
}