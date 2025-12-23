class Salary {
  final double amount;

  Salary(this.amount);

  Map<String, dynamic> toMap() => {'amount': amount};

  factory Salary.fromMap(Map map) => Salary(map['amount']);
}
