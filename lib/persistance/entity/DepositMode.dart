class DepositMode{
  int id;
  int depositModeId;
  String depositModeName;
  String depositModeType;
  String bankingType;

  DepositMode({this.id,this.depositModeId,this.depositModeName,
  this.depositModeType,this.bankingType});
  factory DepositMode.fromJson(Map<String,dynamic> map){
    return DepositMode(
      depositModeId: map['depositModeId'],
      depositModeName: map['depositModeName'],
      depositModeType: map['depositModeType'],
      bankingType: map['bankingType']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'deposit_mode_id': depositModeId,
      'deposit_mode_name': depositModeName,
      'deposit_mode_type': depositModeType,
      'banking_type': bankingType
    };
  }
}