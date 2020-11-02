class Village{

  int villageId;
  String villageName;

  Village({
    this.villageId,
    this.villageName
  });

  Map<String,dynamic> toMap(){
    return {
      'village_id': villageId,
      'village_name': villageName
    };
  }
}