class BusinessReason {
  int businessReasonId;
  String businessReasonName;

  BusinessReason({
    this.businessReasonId,
    this.businessReasonName
  });

  Map<String,dynamic> toMap(){
    return {
      'business_reason_id': businessReasonId,
      'business_reason_name': businessReasonName
    };
  }
}