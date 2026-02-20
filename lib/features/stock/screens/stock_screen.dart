
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/stock_item.dart';
import 'edit_item_screen.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<StockItem>('stock');

    return Scaffold(
      appBar: AppBar(title: const Text("Stock Items"), centerTitle: true),

      /// ➕ ADD ITEM BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditItemScreen()),
          );
          setState(() {});
        },
      ),

      body: Column(
        children: [
          /// 🔎 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search item...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => search = val),
            ),
          ),

          /// 📦 LIVE LIST FROM HIVE
          Expanded(
            child: ValueListenableBuilder<Box<StockItem>>(
              valueListenable: box.listenable(),
              builder: (context, box, _) {
                final allItems = box.values.toList();

                final items = allItems.where((item) {
                  return item.name.toLowerCase().contains(search.toLowerCase());
                }).toList();

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "No stock items yet",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: const Icon(
                            Icons.inventory,
                            color: Colors.green,
                          ),
                        ),

                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("MRP: ₹${item.mrp}"),
                            Text("Qty: ${item.qty} ${item.unit}"),
                            Text("Tax: ${item.tax} (${item.taxType})"),
                          ],
                        ),

                        trailing: const Icon(Icons.edit, size: 18),

                        /// ✏️ EDIT ITEM
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditItemScreen(item: item),
                            ),
                          );
                          setState(() {});
                        },

                        /// 🗑️ DELETE ITEM (LONG PRESS)
                        onLongPress: () async {
                          await item.delete();
                          setState(() {});
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
