class MaritalStatus{
  int maritalStatusId;
  String maritalStatusName;

  MaritalStatus({
    this.maritalStatusId,
    this.maritalStatusName
  });

  Map<String,dynamic> toMap(){
    return {
      'marital_status_id': maritalStatusId,
      'marital_status_name': maritalStatusName
    };
  }
}