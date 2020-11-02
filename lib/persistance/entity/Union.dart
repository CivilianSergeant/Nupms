class Union{
  int unionId;
  String unionName;

  Union({
    this.unionId,
    this.unionName
  });

  Map<String,dynamic> toMap(){
    return {
      'union_id': unionId,
      'union_name': unionName
    };
  }
}