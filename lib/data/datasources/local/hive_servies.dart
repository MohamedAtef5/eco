import 'package:hive/hive.dart';

class HiveService {
  static const categoryBoxName = 'categories_box';
  static const salaryBoxName = 'salary_box';

  static Future<void> openBoxes() async {
    await Hive.openBox(categoryBoxName);
    await Hive.openBox(salaryBoxName);
  }

  static Box get categoryBox => Hive.box(categoryBoxName);
  static Box get salaryBox => Hive.box(salaryBoxName);
}
