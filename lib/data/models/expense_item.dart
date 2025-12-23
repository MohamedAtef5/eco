class ExpenseItem {
  final String id;
  final String name;
  final double price;
  final DateTime date;

  ExpenseItem({
    required this.id,
    required this.name,
    required this.price,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'price': price,
        'date': date.toIso8601String(),
      };

  factory ExpenseItem.fromMap(Map map) {
    return ExpenseItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      date: DateTime.parse(map['date']),
    );
  }
}
