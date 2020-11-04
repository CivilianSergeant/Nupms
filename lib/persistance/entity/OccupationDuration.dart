class OccupationDuration{
  int id;
  String occupationDurationId;
  String occupationDurationName;

  OccupationDuration({
    this.id,
    this.occupationDurationId,
    this.occupationDurationName
  });

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'occupation_duration_id': occupationDurationId,
      'occupation_duration_name': occupationDurationName
    };
  }
}