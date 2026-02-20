

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'add_transaction_screen.dart';
import '../../account/screens/customer_profile_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final String customerName;

  const CustomerDetailScreen({super.key, required this.customerName});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  double calculateBalance(List transactions) {
    double b = 0;
    for (var t in transactions) {
      if (t['type'] == 'GIVEN') {
        b += t['amount'];
      } else {
        b -= t['amount'];
      }
    }
    return b;
  }

  void openTransaction(bool isGiven) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(
          isGiven: isGiven,
          customerName: widget.customerName,
        ),
      ),
    );

    if (result != null) {
      Provider.of<CustomerProvider>(
        context,
        listen: false,
      ).addTransaction(widget.customerName, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final transactions = provider.getTransactions(widget.customerName);

    final balance = calculateBalance(transactions);
    final isDue = balance > 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.customerName),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CustomerProfileScreen(customerName: widget.customerName),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          /// TOP CARD (Customer Info)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  widget.customerName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "₹${balance.abs().toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isDue ? "Due" : "Advance",
                  style: TextStyle(
                    color: isDue ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          /// TRANSACTION CHAT LIST
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text("No transactions yet"))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      final isGiven = t['type'] == 'GIVEN';
                      final DateTime d = t['date'];
                      final note = t['note'] ?? "";

                      return Align(
                        alignment: isGiven
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 260),
                          decoration: BoxDecoration(
                            color: isGiven
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Amount Row
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isGiven
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 16,
                                    color: isGiven ? Colors.red : Colors.green,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "₹${t['amount']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isGiven
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),

                              /// NOTE
                              if (note.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  note,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],

                              const SizedBox(height: 6),

                              /// DATE
                              Text(
                                "${d.day}/${d.month}/${d.year}  ${d.hour}:${d.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          /// BOTTOM BUTTONS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => openTransaction(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade100,
                      foregroundColor: Colors.green,
                    ),
                    child: const Text("Received"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => openTransaction(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      foregroundColor: Colors.red,
                    ),
                    child: const Text("Given"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
