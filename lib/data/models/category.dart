import 'expense_item.dart';

class Category {
  final String id;
  final String name;
  final List<ExpenseItem> items;

  Category({
    required this.id,
    required this.name,
    required this.items,
  });

  double get total => items.fold(0, (sum, item) => sum + item.price);

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'items': items.map((e) => e.toMap()).toList(),
      };

  factory Category.fromMap(Map map) {
    return Category(
      id: map['id'],
      name: map['name'],
      // Add safety mapping for nested Hive lists
      items: (map['items'] as List? ?? [])
          .map((e) => ExpenseItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
