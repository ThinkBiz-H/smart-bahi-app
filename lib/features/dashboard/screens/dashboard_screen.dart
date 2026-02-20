

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import '../../customer/screens/add_customer_screen.dart';
import '../../customer/screens/customer_detail_screen.dart';
import '../../../core/widgets/balance_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final searchController = TextEditingController();

  List filteredList = [];
  int selectedTab = 0; // 0 = Customer , 1 = Supplier

  void searchPerson(String value, List people) {
    if (value.isEmpty) {
      setState(() => filteredList = people);
      return;
    }

    final results = people.where((p) {
      return p.name.toLowerCase().contains(value.toLowerCase());
    }).toList();

    setState(() => filteredList = results);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    final people = selectedTab == 0 ? provider.customers : provider.suppliers;

    final listToShow = searchController.text.isEmpty ? people : filteredList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),

      /// ➕ ADD CUSTOMER / SUPPLIER
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E8E3E),
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
          );

          if (result != null) {
            context.read<CustomerProvider>().addPerson(
              result['name'],
              result['phone'],
              result['address'],
              result['type'].toUpperCase(), // CUSTOMER / SUPPLIER
            );
          }
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const BalanceCard(amount: '₹9,104', label: 'You Get'),
            const SizedBox(height: 16),

            /// 🔍 SEARCH BAR
            TextField(
              controller: searchController,
              onChanged: (v) => searchPerson(v, people),
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          searchController.clear();
                          searchPerson('', people);
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔁 CUSTOMER / SUPPLIER TOGGLE
            Row(
              children: [
                _tabButton("Customer", 0),
                const SizedBox(width: 10),
                _tabButton("Supplier", 1),
              ],
            ),

            const SizedBox(height: 16),

            /// 📄 LIST
            Expanded(
              child: listToShow.isEmpty
                  ? Center(
                      child: Text(
                        selectedTab == 0
                            ? "No customers found"
                            : "No suppliers found",
                      ),
                    )
                  : ListView.builder(
                      itemCount: listToShow.length,
                      itemBuilder: (context, index) {
                        final person = listToShow[index];
                        final balance = person.balance;

                        return _personTile(
                          context,
                          name: person.name,
                          amount: "₹${balance.abs().toStringAsFixed(0)}",
                          isDue: balance > 0,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔘 TAB BUTTON
  Widget _tabButton(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
            searchController.clear();
            filteredList = [];
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selectedTab == index
                ? const Color(0xFF1E8E3E)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selectedTab == index ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// 👤 TILE (Customer + Supplier same)
  Widget _personTile(
    BuildContext context, {
    required String name,
    required String amount,
    required bool isDue,
  }) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1E8E3E),
          child: Text(name[0], style: const TextStyle(color: Colors.white)),
        ),
        title: Text(name),
        subtitle: const Text('Tap to view transactions'),
        trailing: Text(
          amount,
          style: TextStyle(
            color: isDue ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CustomerDetailScreen(customerName: name),
            ),
          );
        },
      ),
    );
  }
}
