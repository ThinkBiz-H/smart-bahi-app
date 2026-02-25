// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import '../../customer/screens/add_customer_screen.dart';
// import '../../customer/screens/customer_detail_screen.dart';
// import '../../../core/widgets/balance_card.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final searchController = TextEditingController();

//   List filteredList = [];
//   int selectedTab = 0;

//   void searchPerson(String value, List people) {
//     if (value.isEmpty) {
//       setState(() => filteredList = people);
//       return;
//     }

//     final results = people.where((p) {
//       return p.name.toLowerCase().contains(value.toLowerCase());
//     }).toList();

//     setState(() => filteredList = results);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);

//     final people = selectedTab == 0 ? provider.customers : provider.suppliers;
//     final listToShow = searchController.text.isEmpty ? people : filteredList;

//     double totalCustomerBalance = 0;
//     for (var c in provider.customers) {
//       if (c.balance > 0) {
//         totalCustomerBalance += c.balance;
//       }
//     }

//     return Scaffold(
//       /// ⭐⭐⭐ APPBAR UPDATED ⭐⭐⭐
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,

//         /// LEFT LOGO
//         title: Row(
//           children: [
//             Image.asset(
//               "assets/images/main-screen20.png", // 👈 apna logo yaha rakho
//               height: 80,
//             ),
//           ],
//         ),

//         /// RIGHT WHATSAPP SHARE
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share, color: Colors.green),
//             onPressed: () {
//               // Future me WhatsApp share
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Share app coming soon")),
//               );
//             },
//           ),
//         ],
//       ),

//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFF0C2752),
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
//           );

//           if (result != null) {
//             context.read<CustomerProvider>().addPerson(
//               result['name'],
//               result['phone'],
//               result['address'],
//               result['type'].toUpperCase(),
//             );
//           }
//         },
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             if (selectedTab == 0) ...[
//               BalanceCard(
//                 amount: "₹${totalCustomerBalance.toStringAsFixed(0)}",
//                 label: 'You Get',
//               ),
//               const SizedBox(height: 16),
//             ],

//             TextField(
//               controller: searchController,
//               onChanged: (v) => searchPerson(v, people),
//               decoration: InputDecoration(
//                 hintText: "Search...",
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.grey.shade100,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 _tabButton("Customer", 0),
//                 const SizedBox(width: 10),
//                 _tabButton("Supplier", 1),
//               ],
//             ),

//             const SizedBox(height: 16),

//             Expanded(
//               child: listToShow.isEmpty
//                   ? Center(
//                       child: Text(
//                         selectedTab == 0
//                             ? "No customers found"
//                             : "No suppliers found",
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: listToShow.length,
//                       itemBuilder: (context, index) {
//                         final person = listToShow[index];
//                         final balance = person.balance;

//                         return _personTile(
//                           context,
//                           person,
//                           amount: "₹${balance.abs().toStringAsFixed(0)}",
//                           isDue: balance > 0,
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _tabButton(String title, int index) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedTab = index;
//             searchController.clear();
//             filteredList = [];
//           });
//         },
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             color: selectedTab == index
//                 ? const Color(0xFF0C2752)
//                 : Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: selectedTab == index ? Colors.white : Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _personTile(
//     BuildContext context,
//     dynamic person, {
//     required String amount,
//     required bool isDue,
//   }) {
//     final provider = Provider.of<CustomerProvider>(context, listen: false);
//     final image = provider.getCustomerImage(person);

//     return Card(
//       elevation: 1,
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: const Color(0xFF1E8E3E),
//           backgroundImage: image,
//           child: image == null
//               ? Text(
//                   person.name[0],
//                   style: const TextStyle(color: Colors.white),
//                 )
//               : null,
//         ),
//         title: Text(person.name),
//         subtitle: const Text('Tap to view transactions'),
//         trailing: Text(
//           amount,
//           style: TextStyle(
//             color: isDue ? Colors.red : Colors.green,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => CustomerDetailScreen(customerName: person.name),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

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
  int selectedTab = 0;

  /// ⭐⭐⭐ AUTO REMINDER TRIGGER WHEN APP OPENS ⭐⭐⭐
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CustomerProvider>().checkAutoReminders();
    });
  }

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

    double totalCustomerBalance = 0;
    for (var c in provider.customers) {
      if (c.balance > 0) {
        totalCustomerBalance += c.balance;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,

        /// LEFT LOGO
        title: Row(
          children: [
            Image.asset("assets/images/main-screen20.png", height: 80),
          ],
        ),

        /// RIGHT SHARE BUTTON
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.green),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Share app coming soon")),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C2752),
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
              result['type'].toUpperCase(),
            );
          }
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (selectedTab == 0) ...[
              BalanceCard(
                amount: "₹${totalCustomerBalance.toStringAsFixed(0)}",
                label: 'You Get',
              ),
              const SizedBox(height: 16),
            ],

            /// SEARCH
            TextField(
              controller: searchController,
              onChanged: (v) => searchPerson(v, people),
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                _tabButton("Customer", 0),
                const SizedBox(width: 10),
                _tabButton("Supplier", 1),
              ],
            ),

            const SizedBox(height: 16),

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
                          person,
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
                ? const Color(0xFF0C2752)
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

  Widget _personTile(
    BuildContext context,
    dynamic person, {
    required String amount,
    required bool isDue,
  }) {
    final provider = Provider.of<CustomerProvider>(context, listen: false);
    final image = provider.getCustomerImage(person);

    return Card(
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1E8E3E),
          backgroundImage: image,
          child: image == null
              ? Text(
                  person.name[0],
                  style: const TextStyle(color: Colors.white),
                )
              : null,
        ),
        title: Text(person.name),
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
              builder: (_) => CustomerDetailScreen(customerName: person.name),
            ),
          );
        },
      ),
    );
  }
}
