import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/expense_item.dart';
import '../providers/category_provider.dart';
import '../widgets/expense_tile.dart';

class CategoryScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryScreen(this.categoryId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(singleCategoryProvider(categoryId));

    if (category == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addItem(context, ref),
        label: const Text("Add Item"),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // ===== Total Card =====
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "${category.total} EGP",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ===== Items List =====
          Expanded(
            child: category.items.isEmpty
                ? const Center(child: Text("No items yet"))
                : ListView.builder(
                    itemCount: category.items.length,
                    itemBuilder: (_, i) {
                      final item = category.items[i];
                      return ExpenseTile(
                        item: item,
                        onDelete: () {
                          ref
                              .read(categoryProvider.notifier)
                              .deleteItem(category.id, item.id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _addItem(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final price = double.tryParse(priceCtrl.text);

                  if (name.isEmpty || price == null) return;

                  ref.read(categoryProvider.notifier).addItem(
                        categoryId,
                        ExpenseItem(
                          id: const Uuid().v4(),
                          name: name,
                          price: price,
                          date: DateTime.now(),
                        ),
                      );

                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }
}
