import 'package:expense_tracker/data/datasources/local/hive_servies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/salary.dart';

final salaryProvider = StateNotifierProvider<SalaryNotifier, Salary>(
  (ref) => SalaryNotifier()..load(),
);

class SalaryNotifier extends StateNotifier<Salary> {
  SalaryNotifier() : super(Salary(0));

  void load() {
    final box = HiveService.salaryBox;
    if (box.isNotEmpty) {
      state = Salary.fromMap(Map.from(box.getAt(0)));
    }
  }

  void update(double value) {
    state = Salary(value);
    final box = HiveService.salaryBox;
    box.clear();
    box.add(state.toMap());
  }
}
