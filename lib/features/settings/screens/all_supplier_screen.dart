import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import '../../../models/customer_model.dart';

class AllSupplierScreen extends StatefulWidget {
  const AllSupplierScreen({super.key});

  @override
  State<AllSupplierScreen> createState() => _AllSupplierScreenState();
}

class _AllSupplierScreenState extends State<AllSupplierScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    final allSuppliers = provider.allSuppliers;
    final hiddenSuppliers = provider.hiddenSuppliers;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Suppliers"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "All Suppliers"),
            Tab(text: "Hidden"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          /// ALL SUPPLIERS
          ListView.builder(
            itemCount: allSuppliers.length,
            itemBuilder: (context, index) {
              Customer supplier = allSuppliers[index];

              return CheckboxListTile(
                title: Text(supplier.name),
                subtitle: Text(supplier.mobile),
                value: supplier.isHidden,
                onChanged: (value) {
                  provider.toggleHidden(supplier, value!);
                },
              );
            },
          ),

          /// HIDDEN SUPPLIERS
          ListView.builder(
            itemCount: hiddenSuppliers.length,
            itemBuilder: (context, index) {
              Customer supplier = hiddenSuppliers[index];

              return ListTile(
                title: Text(supplier.name),
                subtitle: Text(supplier.mobile),
                trailing: TextButton(
                  child: const Text("Unhide"),
                  onPressed: () {
                    provider.toggleHidden(supplier, false);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
