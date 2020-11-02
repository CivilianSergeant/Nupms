class Education{
  int educationId;
  String educationName;

  Education({
    this.educationId,this.educationName
  });

  Map<String,dynamic> toMap(){
    return {
      'education_id': educationId,
      'education_name': educationName
    };
  }
}