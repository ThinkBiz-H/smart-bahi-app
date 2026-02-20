

//MAIN BILL SECTION

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import '../../stock/models/stock_item.dart';

class BillPreviewScreen extends StatefulWidget {
  final int? billKey;

  final List<Map<String, dynamic>> items;
  final String customerName;
  final String mobile;
  final String address;
  final String billNumber;
  final DateTime billDate;
  final double subTotal;
  final double charges;
  final double discount;
  final double gstTotal;
  final double cessTotal;
  final double grandTotal;

  const BillPreviewScreen({
    super.key,
    required this.billKey,
    required this.items,
    required this.customerName,
    required this.mobile,
    required this.address,
    required this.billNumber,
    required this.billDate,
    required this.subTotal,
    required this.charges,
    required this.discount,
    required this.gstTotal,
    required this.cessTotal,
    required this.grandTotal,
  });

  @override
  State<BillPreviewScreen> createState() => _BillPreviewScreenState();
}

class _BillPreviewScreenState extends State<BillPreviewScreen> {
  bool isPaid = false;

  Future<void> saveBill() async {
    final billBox = Hive.box('bills');
    final stockBox = Hive.box<StockItem>('stock');
    final provider = context.read<CustomerProvider>();

    final billData = {
      "customerName": widget.customerName,
      "mobile": widget.mobile,
      "billNumber": widget.billNumber,
      "date": widget.billDate.toIso8601String(),
      "items": widget.items,
      "subTotal": widget.subTotal,
      "gst": widget.gstTotal,
      "cess": widget.cessTotal,
      "charges": widget.charges,
      "discount": widget.discount,
      "grandTotal": widget.grandTotal,
      "paid": isPaid,
    };

    /// EDIT MODE FIX (duplicate + ledger reverse)
    if (widget.billKey != null) {
      final oldBill = billBox.get(widget.billKey);

      if ((oldBill['paid'] ?? false) == false) {
        provider.addTransaction(widget.customerName, {
          'amount': widget.grandTotal,
          'note': 'Bill Edited Reverse',
          'date': DateTime.now(),
          'type': 'RECEIVED',
        });
      }

      await billBox.put(widget.billKey, billData);
    } else {
      await billBox.add(billData);

      /// STOCK REDUCE ONLY FOR NEW BILL
      for (var billItem in widget.items) {
        try {
          final stockItem = stockBox.values.firstWhere(
            (i) => i.name.toLowerCase() == billItem['name'].toLowerCase(),
          );

          int currentStock = int.tryParse(stockItem.qty) ?? 0;
          int soldQty = (billItem['qty'] as double).toInt();

          stockItem
            ..qty = (currentStock - soldQty).toString()
            ..save();
        } catch (_) {}
      }
    }

    /// ensure customer exists
    try {
      provider.getCustomer(widget.customerName);
    } catch (_) {
      provider.addCustomer(widget.customerName, widget.mobile, widget.address);
    }

    /// ledger sync
    if (!isPaid) {
      provider.addTransaction(widget.customerName, {
        'amount': widget.grandTotal,
        'note': 'Bill ${widget.billNumber}',
        'date': DateTime.now(),
        'type': 'GIVEN',
      });
    }

    Navigator.popUntil(context, (route) => route.isFirst);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Bill Saved")));
  }

  Widget row(String title, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
          ),
          Text(
            "₹${value.toStringAsFixed(0)}",
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text(widget.billNumber)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// CUSTOMER HEADER
                    Center(
                      child: Column(
                        children: [
                          Text(
                            widget.customerName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Mobile: ${widget.mobile}"),
                          Text(widget.address),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BILL INFO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bill No: ${widget.billNumber}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${widget.billDate.day}/${widget.billDate.month}/${widget.billDate.year}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const Divider(height: 30),

                    /// ITEMS HEADER
                    const Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Item",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Qty",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Rate",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Total",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),

                    /// ITEMS LIST
                    ...widget.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text(item['name'])),
                            Expanded(
                              child: Text(
                                "${item['qty']}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "₹${item['rate']}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "₹${item['baseAmount']}",
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(height: 30),

                    row("Sub Total", widget.subTotal),
                    row("Extra Charge", widget.charges),
                    row("Discount", -widget.discount),
                    row("GST", widget.gstTotal),
                    row("Cess", widget.cessTotal),
                    const Divider(),
                    row("TOTAL", widget.grandTotal, bold: true),
                  ],
                ),
              ),
            ),
          ),

          /// PAYMENT + SAVE
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Payment status"),
                    const Spacer(),
                    Radio(
                      value: true,
                      groupValue: isPaid,
                      onChanged: (_) => setState(() => isPaid = true),
                    ),
                    const Text("Paid"),
                    Radio(
                      value: false,
                      groupValue: isPaid,
                      onChanged: (_) => setState(() => isPaid = false),
                    ),
                    const Text("Unpaid"),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: saveBill,
                  child: const Text("Save Bill"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
