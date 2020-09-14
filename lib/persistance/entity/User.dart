class User{

  int id;
  int unitId;
  String unitName;
  int areaId;
  String areaName;
  int zoneId;
  String zoneName;
  int employeeId;
  String employeeCode;
  String employeeName;
  bool downloadMaster;


  User({
    this.id,
    this.unitId,
    this.unitName,
    this.areaId,
    this.areaName,
    this.zoneId,
    this.zoneName,
    this.employeeId,
    this.employeeCode,
    this.employeeName,
    this.downloadMaster
  });

  factory User.fromJSON(Map<String,dynamic> map){
    return User(
        id: map['id'],
        unitId: map['unit_id'],
        unitName: map['unit_name'],
        areaId: map['area_id'],
        areaName: map['areaName'],
        zoneId: map['zone_id'],
        zoneName: map['zone_name'],
        employeeId: map['employeeId'],
        employeeCode: map['employeeCode'],
        employeeName: map['employeeName'],
        downloadMaster: (map['download_master']==1)? true : false
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "unit_id": unitId,
      "unit_name": unitName,
      "area_id": areaId,
      "area_name": areaName,
      "zone_id": zoneId,
      "zone_name": zoneName,
      "employee_id": employeeId,
      "employee_code": employeeCode,
      "employee_name": employeeName,
      "download_master": (downloadMaster)? 1 : 0
    };
  }
  
}