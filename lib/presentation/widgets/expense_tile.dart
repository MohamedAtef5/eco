import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/expense_item.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseItem item;
  final VoidCallback onDelete;

  const ExpenseTile({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. السعر (Price Section)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE), // أحمر فاتح جداً خلف السعر
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "- ${item.price.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Color(0xFFD32F2F), // لون السعر أحمر
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 2. الفاصل الرأسي (Vertical Divider)
          Container(
            height: 30,
            width: 1,
            color: Colors.grey.withOpacity(0.2),
          ),

          const SizedBox(width: 16),

          // 3. اسم العنصر والتاريخ (Info Section)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(item.date),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // 4. زر الحذف (Delete Button)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
