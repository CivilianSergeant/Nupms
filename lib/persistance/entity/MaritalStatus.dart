class MaritalStatus{
  int id;
  String maritalStatusId;
  String maritalStatusName;

  MaritalStatus({
    this.id,
    this.maritalStatusId,
    this.maritalStatusName
  });

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'marital_status_id': maritalStatusId,
      'marital_status_name': maritalStatusName
    };
  }
}