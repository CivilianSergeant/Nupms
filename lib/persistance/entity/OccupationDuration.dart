class OccupationDuration{
  int occupationDurationId;
  String occupationDurationName;

  OccupationDuration({
    this.occupationDurationId,
    this.occupationDurationName
  });

  Map<String,dynamic> toMap(){
    return {
      'occupation_duration_id': occupationDurationId,
      'occupation_duration_name': occupationDurationName
    };
  }
}