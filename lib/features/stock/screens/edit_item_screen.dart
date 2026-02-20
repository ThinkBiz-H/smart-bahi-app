

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/stock_item.dart';

class EditItemScreen extends StatefulWidget {
  final StockItem? item;

  const EditItemScreen({super.key, this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final nameCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final mrpCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final codeCtrl = TextEditingController();

  String unitValue = "Nos";
  String taxValue = "0%";
  String taxType = "Included";
  String selectedDate = "";
  String imagePath = "";

  bool showMore = true;

  bool get isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now().toString().substring(0, 10);

    if (isEdit) {
      final item = widget.item!;

      nameCtrl.text = item.name;
      qtyCtrl.text = item.qty;
      mrpCtrl.text = item.mrp;
      rateCtrl.text = item.rate;
      codeCtrl.text = item.productCode;

      unitValue = item.unit;
      taxValue = item.tax;
      taxType = item.taxType;
      selectedDate = item.date;
      imagePath = item.imagePath;
    }
  }

  void saveItem() {
    final box = Hive.box<StockItem>('stock');

    final newItem = StockItem(
      name: nameCtrl.text,
      mrp: mrpCtrl.text,
      qty: qtyCtrl.text,
      unit: unitValue,
      rate: rateCtrl.text,
      date: selectedDate,
      tax: taxValue,
      taxType: taxType,
      productCode: codeCtrl.text,
      imagePath: imagePath,
    );

    if (isEdit) {
      widget.item!
        ..name = newItem.name
        ..mrp = newItem.mrp
        ..qty = newItem.qty
        ..unit = newItem.unit
        ..rate = newItem.rate
        ..date = newItem.date
        ..tax = newItem.tax
        ..taxType = newItem.taxType
        ..productCode = newItem.productCode
        ..imagePath = newItem.imagePath
        ..save();
    } else {
      box.add(newItem);
    }

    Navigator.pop(context);
  }

  Widget inputField(String hint, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget dropdown(List<String> items, String value, Function(String) onChange) {
    return DropdownButtonFormField(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChange(v.toString()),
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Item" : "New Item")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            inputField("Item Name", nameCtrl),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: inputField("MRP", mrpCtrl)),
                const SizedBox(width: 10),
                Expanded(child: inputField("Qty", qtyCtrl)),
              ],
            ),
            const SizedBox(height: 12),

            dropdown(
              ["Nos", "Kg", "Litres", "Packets", "Pieces"],
              unitValue,
              (v) => setState(() => unitValue = v),
            ),

            TextButton(
              onPressed: () => setState(() => showMore = !showMore),
              child: Text(showMore ? "Hide details" : "View more details"),
            ),

            if (showMore) ...[
              inputField("Rate", rateCtrl),
              const SizedBox(height: 12),

              dropdown(
                ["0%", "5%", "12%", "18%"],
                taxValue,
                (v) => setState(() => taxValue = v),
              ),
              const SizedBox(height: 12),

              dropdown(
                ["Included", "Excluded"],
                taxType,
                (v) => setState(() => taxType = v),
              ),
              const SizedBox(height: 12),

              inputField("Product Code", codeCtrl),
            ],

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveItem,
                child: const Text("SAVE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
