class MonthlyIncome{

  int id;
  String monthlyIncome;

  MonthlyIncome({
    this.id,
    this.monthlyIncome
  });

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'monthly_income': monthlyIncome
    };
  }

}