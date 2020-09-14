class DepositMode{
  int depositModeId;
  String depositModeName;

  DepositMode({this.depositModeId,this.depositModeName});
  factory DepositMode.fromJson(Map<String,dynamic> map){
    return DepositMode(
      depositModeId: map['depositModeId'],
      depositModeName: map['depositModeName']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'deposit_mode_id': depositModeId,
      'deposit_mode_name': depositModeName
    };
  }
}