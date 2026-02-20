import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';

class SupplierAccountStatementScreen extends StatelessWidget {
  const SupplierAccountStatementScreen({super.key});
  String _formatTime(String? time) {
    if (time == null) return "";

    final dt = DateTime.tryParse(time);
    if (dt == null) return "";

    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final suppliers = provider.suppliers;

    /// ⭐ ALL SUPPLIER TRANSACTIONS MERGE
    List<Map<String, dynamic>> allTx = [];

    for (var s in suppliers) {
      for (var tx in s.transactions) {
        allTx.add({
          "name": s.name,
          "amount": tx["amount"],
          "type": tx["type"],
          "time": tx["time"], // ⭐ YE ADD KARO
        });
      }
    }

    /// CALCULATIONS
    double totalCredit = 0;
    double totalPayment = 0;

    for (var tx in allTx) {
      if (tx["type"] == "GIVEN") {
        totalCredit += tx["amount"];
      } else {
        totalPayment += tx["amount"];
      }
    }

    double netBalance = totalCredit - totalPayment;

    return Scaffold(
      appBar: AppBar(title: const Text("Supplier Statement")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          /// DATE CHIP
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(width: 6),
                Text("Today"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// TOP CARD
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                const Text("Net Balance"),
                Text(
                  "₹${netBalance.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.arrow_downward, color: Colors.green),
                        Text(
                          "₹${totalPayment.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),
                        const Text("Payments"),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.arrow_upward, color: Colors.red),
                        Text(
                          "₹${totalCredit.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        const Text("Credits"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// TIMELINE LIST
          Expanded(
            child: ListView.builder(
              itemCount: allTx.length,
              itemBuilder: (context, index) {
                final tx = allTx[index];
                bool isCredit = tx["type"] == "GIVEN";

                return Align(
                  alignment: isCredit
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCredit
                          ? Colors.red.shade50
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tx["name"]),
                        Text(
                          "₹${tx["amount"]}",
                          style: TextStyle(
                            color: isCredit ? Colors.red : Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          tx["time"] != null
                              ? _formatTime(tx["time"])
                              : "No Time",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
