import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'salary_provider.dart';
import 'category_provider.dart';

final balanceProvider = Provider<double>((ref) {
  final salary = ref.watch(salaryProvider).amount;
  final categories = ref.watch(categoryProvider);

  final spent = categories.fold(
    0.0,
    (sum, c) => sum + c.total,
  );

  return salary - spent;
});
