class TrainingInfo{
  int trainingId;
  String trainingName;

  TrainingInfo({
    this.trainingId,
    this.trainingName
  });

  Map<String,dynamic> toMap(){
    return {
      'training_id': trainingId,
      'training_name': trainingName
    };
  }
}