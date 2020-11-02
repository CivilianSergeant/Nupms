class Occupation{
  int occupationId;
  String occupationName;

  Occupation({
    this.occupationId,
    this.occupationName
  });

  Map<String,dynamic> toMap(){
    return {
      'occupation_id': occupationId,
      'occupation_name': occupationName
    };
  }

}