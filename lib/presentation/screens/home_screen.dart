import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../providers/salary_provider.dart';
import '../providers/category_provider.dart';
import '../providers/balance_provider.dart';
import '../widgets/category_card.dart';
import '../../data/models/category.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    final balance = ref.watch(balanceProvider);
    final salary = ref.watch(salaryProvider).amount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Econemy Tracker",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: const Color(0xFFF5F5F7), // Off-white background
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCategory(context, ref),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Dashboard Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E3A8A), // Dark Blue
                  Color(0xFF6D28D9), // Purple
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Monthly Salary",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$salary EGP",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Remaining: $balance EGP",
                      style: TextStyle(
                        color:
                            balance < 0 ? Colors.redAccent : Colors.greenAccent,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _editSalary(context, ref),
                ),
              ],
            ),
          ),

          // Categories List
          Expanded(
            child: categories.isEmpty
                ? const Center(child: Text("No categories yet"))
                : ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (_, i) => CategoryCard(
                      category: categories[i],
                      index: i, // ✅ ل Gradient مختلف
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ================= CATEGORY =================

  void _addCategory(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ✅ تحرك مع الكيبورد
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add Category",
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: "Category name"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isEmpty) return;

                    ref.read(categoryProvider.notifier).addCategory(
                          Category(
                            id: const Uuid().v4(),
                            name: controller.text.trim(),
                            items: [],
                          ),
                        );
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= SALARY =================

  void _editSalary(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: ref.read(salaryProvider).amount.toString(),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Salary"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Salary"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value == null) return;

              ref.read(salaryProvider.notifier).update(value);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
