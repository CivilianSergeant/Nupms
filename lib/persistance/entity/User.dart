class User{

  int id;
  String orgShortCode;
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
  int countryId;
  String countryName;
  int divisionId;
  String divisionName;
  int districtId;
  String districtName;

  User({
    this.id,
    this.orgShortCode,
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
        orgShortCode: map['orgShortCode'],
        unitId: map['unitId'],
        unitName: map['unitName'],
        areaId: map['areaId'],
        areaName: map['areaName'],
        zoneId: map['zoneId'],
        zoneName: map['zoneName'],
        employeeId: map['employeeId'],
        employeeCode: map['employeeCode'],
        employeeName: map['employeeName'],
        downloadMaster:  false
    );
  }

  factory User.fromMap(Map<String,dynamic> map){
    return User(
        id: map['id'],
        orgShortCode: map['org_short_code'],
        unitId: map['unit_id'],
        unitName: map['unit_name'],
        areaId: map['area_id'],
        areaName: map['area_name'],
        zoneId: map['zone_id'],
        zoneName: map['zone_name'],
        employeeId: map['employee_id'],
        employeeCode: map['employee_code'],
        employeeName: map['employee_name'],
        downloadMaster:  false
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "org_short_code": orgShortCode,
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