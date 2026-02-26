// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart' hide Customer;
// import 'package:frontend/models/customer_model.dart';

// class ReminderCustomersScreen extends StatefulWidget {
//   const ReminderCustomersScreen({super.key});

//   @override
//   State<ReminderCustomersScreen> createState() =>
//       _ReminderCustomersScreenState();
// }

// class _ReminderCustomersScreenState extends State<ReminderCustomersScreen> {
//   final Map<String, bool> selectedCustomers = {};

//   void toggleAll(List<Customer> customers, bool value) {
//     setState(() {
//       for (var c in customers) {
//         selectedCustomers[c.name] = value;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final customers = context.watch<CustomerProvider>().customers;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Set Reminder"), centerTitle: true),

//       body: Column(
//         children: [
//           /// Select All Checkbox
//           CheckboxListTile(
//             title: const Text(
//               "Select All Customers",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             value:
//                 customers.isNotEmpty &&
//                 selectedCustomers.length == customers.length &&
//                 !selectedCustomers.values.contains(false),
//             onChanged: (val) => toggleAll(customers, val ?? false),
//           ),

//           const Divider(),

//           /// Customers List
//           Expanded(
//             child: ListView.builder(
//               itemCount: customers.length,
//               itemBuilder: (context, index) {
//                 final customer = customers[index];
//                 final isSelected = selectedCustomers[customer.name] ?? false;

//                 return CheckboxListTile(
//                   value: isSelected,
//                   onChanged: (value) {
//                     setState(() {
//                       selectedCustomers[customer.name] = value ?? false;
//                     });
//                   },
//                   title: Text(customer.name),
//                   subtitle: Text(customer.mobile),
//                   secondary: const Icon(Icons.person),
//                 );
//               },
//             ),
//           ),

//           /// Set Reminder Button
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: () {
//                   final selected = selectedCustomers.entries
//                       .where((e) => e.value)
//                       .map((e) => e.key)
//                       .toList();

//                   if (selected.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Select customers first")),
//                     );
//                     return;
//                   }

//                   showDatePicker(
//                     context: context,
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2030),
//                     initialDate: DateTime.now(),
//                   ).then((date) {
//                     if (date == null) return;

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           "Reminder set for ${selected.length} customers on ${date.toString().substring(0, 10)}",
//                         ),
//                       ),
//                     );
//                   });
//                 },
//                 child: const Text(
//                   "SET REMINDER",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'package:frontend/models/customer_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ReminderCustomersScreen extends StatefulWidget {
  const ReminderCustomersScreen({super.key});

  @override
  State<ReminderCustomersScreen> createState() =>
      _ReminderCustomersScreenState();
}

class _ReminderCustomersScreenState extends State<ReminderCustomersScreen> {
  final Map<String, bool> selectedCustomers = {};

  void toggleAll(List<Customer> customers, bool value) {
    setState(() {
      for (var c in customers) {
        selectedCustomers[c.name] = value;
      }
    });
  }

  /// ⭐ BULK SMS FUNCTION
  Future<void> sendBulkSMS(List<Customer> customers) async {
    for (var customer in customers) {
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: customer.mobile,
        queryParameters: {
          'body':
              "Reminder: Hi ${customer.name}, please clear your pending balance. - SmartBahi",
        },
      );

      await launchUrl(smsUri);

      /// wait before opening next SMS
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    final customers = context.watch<CustomerProvider>().customers;

    return Scaffold(
      appBar: AppBar(title: const Text("Set Reminder"), centerTitle: true),
      body: Column(
        children: [
          /// SELECT ALL
          CheckboxListTile(
            title: const Text(
              "Select All Customers",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            value:
                customers.isNotEmpty &&
                selectedCustomers.length == customers.length &&
                !selectedCustomers.values.contains(false),
            onChanged: (val) => toggleAll(customers, val ?? false),
          ),

          const Divider(),

          /// CUSTOMER LIST
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                final isSelected = selectedCustomers[customer.name] ?? false;

                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      selectedCustomers[customer.name] = value ?? false;
                    });
                  },
                  title: Text(customer.name),
                  subtitle: Text(customer.mobile),
                  secondary: const Icon(Icons.person),
                );
              },
            ),
          ),

          /// SET REMINDER BUTTON (⭐ FIXED)
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final provider = context.read<CustomerProvider>();

                  final selected = selectedCustomers.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .toList();

                  if (selected.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Select customers first")),
                    );
                    return;
                  }

                  final selectedCustomersList = selected
                      .map((name) => provider.getCustomer(name))
                      .toList();

                  await sendBulkSMS(selectedCustomersList);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Bulk reminder started for ${selected.length} customers",
                      ),
                    ),
                  );
                },
                child: const Text(
                  "SEND BULK SMS",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
