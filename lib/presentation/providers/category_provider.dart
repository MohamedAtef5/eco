import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/hive_servies.dart';
import '../../data/models/category.dart';
import '../../data/models/expense_item.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>(
  (ref) => CategoryNotifier()..load(),
);

// Provider مخصص لفئة واحدة (آمن)
final singleCategoryProvider = Provider.family<Category?, String>((ref, id) {
  final categories = ref.watch(categoryProvider);
  try {
    return categories.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
});

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]);

  static const String _storageKey = 'all_categories_data';

  void load() {
    final box = HiveService.categoryBox;
    final List? data = box.get(_storageKey);

    if (data != null) {
      state = data.map((e) => Category.fromMap(Map.from(e))).toList();
    }
  }

  void _save() {
    final box = HiveService.categoryBox;
    box.put(
      _storageKey,
      state.map((c) => c.toMap()).toList(),
    );
  }

  void addCategory(Category category) {
    state = [...state, category];
    _save();
  }

  void deleteCategory(String id) {
    state = state.where((c) => c.id != id).toList();
    _save();
  }

  void addItem(String categoryId, ExpenseItem item) {
    state = state.map((c) {
      if (c.id == categoryId) {
        return Category(
          id: c.id,
          name: c.name,
          items: [...c.items, item],
        );
      }
      return c;
    }).toList();

    _save();
  }

  void deleteItem(String categoryId, String itemId) {
    state = state.map((c) {
      if (c.id == categoryId) {
        return Category(
          id: c.id,
          name: c.name,
          items: c.items.where((i) => i.id != itemId).toList(),
        );
      }
      return c;
    }).toList();

    _save();
  }
}
