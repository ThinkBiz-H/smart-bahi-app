

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import 'bill_preview_screen.dart';
import 'create_bill_screen.dart';

class BillsHistoryScreen extends StatelessWidget {
  const BillsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('bills');
    final keys = box.keys.toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Saved Bills")),
      body: keys.isEmpty
          ? const Center(child: Text("No Bills Saved Yet"))
          : ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final key = keys[index];
                final bill = box.get(key);

                final bool isPaid = bill['paid'] ?? false;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Bill ${bill['billNumber']}"),
                    subtitle: Text(bill['customerName']),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("₹${bill['grandTotal']}"),
                        Text(
                          isPaid ? "Paid" : "Unpaid",
                          style: TextStyle(
                            color: isPaid ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),

                    /// 🔥 LONG PRESS → TOGGLE PAID/UNPAID
                    onLongPress: () {
                      final customerProvider = Provider.of<CustomerProvider>(
                        context,
                        listen: false,
                      );

                      final newStatus = !isPaid;

                      box.put(key, {...bill, 'paid': newStatus});

                      if (newStatus) {
                        /// Marked Paid → remove ledger (RECEIVED)
                        customerProvider.addTransaction(bill['customerName'], {
                          'amount': (bill['grandTotal'] as num).toDouble(),
                          'note': 'Bill ${bill['billNumber']} Paid',
                          'date': DateTime.now(),
                          'type': 'RECEIVED',
                        });
                      } else {
                        /// Marked Unpaid → add ledger (GIVEN)
                        customerProvider.addTransaction(bill['customerName'], {
                          'amount': (bill['grandTotal'] as num).toDouble(),
                          'note': 'Bill ${bill['billNumber']} Unpaid',
                          'date': DateTime.now(),
                          'type': 'GIVEN',
                        });
                      }
                    },

                    /// 🔥 TAP → OPEN EDIT MODE (NO DUPLICATE)
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateBillScreen(
                            billKey: key,
                            existingBill: bill,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
