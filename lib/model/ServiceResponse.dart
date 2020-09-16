class ServiceResponse{
  int status;
  String message;

  ServiceResponse({
    this.status,
    this.message
  });

  Map<String,dynamic> toMap(){
    return {
      'status':status,
      'message': message
    };
  }
}