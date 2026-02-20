

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../stock/models/stock_item.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final nameController = TextEditingController();
  final qtyController = TextEditingController(text: "1");
  final rateController = TextEditingController(text: "0");
  final cessController = TextEditingController(text: "0");

  double gstPercent = 0;
  String selectedUnit = "Nos";

  List<StockItem> stockItems = [];
  List<StockItem> suggestions = [];

  @override
  void initState() {
    super.initState();
    stockItems = Hive.box<StockItem>('stock').values.toList();
  }

  void searchItem(String value) {
    suggestions = stockItems
        .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  void selectStockItem(StockItem item) {
    nameController.text = item.name;
    rateController.text = item.rate;
    selectedUnit = item.unit;
    gstPercent = double.tryParse(item.tax.replaceAll("%", "")) ?? 0;
    suggestions.clear();
    setState(() {});
  }

  double get baseAmount =>
      (double.tryParse(qtyController.text) ?? 0) *
      (double.tryParse(rateController.text) ?? 0);

  double get gstAmount => baseAmount * gstPercent / 100;
  double get cessAmount => double.tryParse(cessController.text) ?? 0;

  void saveItem() {
    if (nameController.text.isEmpty) return;

    Navigator.pop(context, [
      {
        "name": nameController.text,
        "qty": double.parse(qtyController.text),
        "unit": selectedUnit,
        "rate": double.parse(rateController.text),
        "gstPercent": gstPercent,
        "baseAmount": baseAmount,
        "gstAmount": gstAmount,
        "cessAmount": cessAmount,
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Item")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔎 ITEM NAME
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Item Name"),
              onChanged: searchItem,
            ),

            /// AUTO SUGGEST
            if (suggestions.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder: (_, i) {
                    final item = suggestions[i];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                        "Stock: ${item.qty} ${item.unit} | Rate: ₹${item.rate}",
                      ),
                      onTap: () => selectStockItem(item),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            /// QTY + UNIT
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Quantity"),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: selectedUnit),
                    readOnly: true,
                    decoration: const InputDecoration(labelText: "Unit"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// RATE
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Rate"),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 16),

            /// GST
            DropdownButtonFormField<double>(
              value: gstPercent,
              decoration: const InputDecoration(labelText: "GST"),
              items: [0, 5, 12, 18, 28]
                  .map(
                    (g) => DropdownMenuItem(
                      value: g.toDouble(),
                      child: Text("$g %"),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => gstPercent = v!),
            ),

            const SizedBox(height: 16),

            /// CESS
            TextField(
              controller: cessController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Cess"),
              onChanged: (_) => setState(() {}),
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: saveItem,
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
