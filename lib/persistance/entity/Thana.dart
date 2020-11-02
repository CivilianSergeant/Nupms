class Thana{
  int thanaId;
  String thanaName;

  Thana({
    this.thanaId,
    this.thanaName
  });

  Map<String,dynamic> toMap(){
    return {
      'thana_id': thanaId,
      'thana_name': thanaName
    };
  }
}