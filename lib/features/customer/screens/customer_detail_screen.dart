// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'add_transaction_screen.dart';
// import '../../account/screens/customer_profile_screen.dart';

// class CustomerDetailScreen extends StatefulWidget {
//   final String customerName;

//   const CustomerDetailScreen({super.key, required this.customerName});

//   @override
//   State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
// }

// class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
//   double calculateBalance(List transactions) {
//     double b = 0;
//     for (var t in transactions) {
//       if (t['type'] == 'GIVEN') {
//         b += t['amount'];
//       } else {
//         b -= t['amount'];
//       }
//     }
//     return b;
//   }

//   void openTransaction(bool isGiven) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddTransactionScreen(
//           isGiven: isGiven,
//           customerName: widget.customerName,
//         ),
//       ),
//     );

//     if (result != null) {
//       Provider.of<CustomerProvider>(
//         context,
//         listen: false,
//       ).addTransaction(widget.customerName, result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final transactions = provider.getTransactions(widget.customerName);
//     final customer = provider.getCustomerByName(widget.customerName);
//     final balance = calculateBalance(transactions);
//     final isDue = balance > 0;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(widget.customerName),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       CustomerProfileScreen(customerName: widget.customerName),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),

//       body: Column(
//         children: [
//           /// TOP CARD (Customer Info)
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Text(
//                   widget.customerName,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "₹${balance.abs().toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   isDue ? "Due" : "Advance",
//                   style: TextStyle(
//                     color: isDue ? Colors.red : Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 6),

//           /// TRANSACTION CHAT LIST
//           Expanded(
//             child: transactions.isEmpty
//                 ? const Center(child: Text("No transactions yet"))
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: transactions.length,
//                     itemBuilder: (context, index) {
//                       final t = transactions[index];
//                       final isGiven = t['type'] == 'GIVEN';
//                       final DateTime d =
//                           DateTime.tryParse(t['time'] ?? "") ?? DateTime.now();
//                       final note = t['note'] ?? "";

//                       return Align(
//                         alignment: isGiven
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           padding: const EdgeInsets.all(12),
//                           constraints: const BoxConstraints(maxWidth: 260),
//                           decoration: BoxDecoration(
//                             color: isGiven
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               /// Amount Row
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     isGiven
//                                         ? Icons.arrow_upward
//                                         : Icons.arrow_downward,
//                                     size: 16,
//                                     color: isGiven ? Colors.red : Colors.green,
//                                   ),
//                                   const SizedBox(width: 6),
//                                   Text(
//                                     "₹${t['amount']}",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: isGiven
//                                           ? Colors.red
//                                           : Colors.green,
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               /// NOTE
//                               if (note.isNotEmpty) ...[
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   note,
//                                   style: const TextStyle(fontSize: 13),
//                                 ),
//                               ],

//                               const SizedBox(height: 6),

//                               /// DATE
//                               Text(
//                                 "${d.day}/${d.month}/${d.year}  ${d.hour}:${d.minute.toString().padLeft(2, '0')}",
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           /// BOTTOM BUTTONS
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(false),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green.shade100,
//                       foregroundColor: Colors.green,
//                     ),
//                     child: const Text("Received"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(true),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red.shade100,
//                       foregroundColor: Colors.red,
//                     ),
//                     child: const Text("Given"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'add_transaction_screen.dart';
// import '../../account/screens/customer_profile_screen.dart';

// class CustomerDetailScreen extends StatefulWidget {
//   final String customerName;

//   const CustomerDetailScreen({super.key, required this.customerName});

//   @override
//   State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
// }

// class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
//   double calculateBalance(List transactions) {
//     double b = 0;
//     for (var t in transactions) {
//       if (t['type'] == 'GIVEN') {
//         b += t['amount'];
//       } else {
//         b -= t['amount'];
//       }
//     }
//     return b;
//   }

//   void openTransaction(bool isGiven) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddTransactionScreen(
//           isGiven: isGiven,
//           customerName: widget.customerName,
//         ),
//       ),
//     );

//     if (result != null) {
//       Provider.of<CustomerProvider>(
//         context,
//         listen: false,
//       ).addTransaction(widget.customerName, result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final transactions = provider.getTransactions(widget.customerName);
//     final customer = provider.getCustomerByName(widget.customerName);
//     final balance = calculateBalance(transactions);
//     final isDue = balance > 0;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(widget.customerName),
//         actions: [
//           /// ✅ FIXED PROFILE NAVIGATION
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CustomerProfileScreen(customer: customer),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),

//       body: Column(
//         children: [
//           /// TOP CARD
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Text(
//                   widget.customerName,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "₹${balance.abs().toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   isDue ? "Due" : "Advance",
//                   style: TextStyle(
//                     color: isDue ? Colors.red : Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 6),

//           /// TRANSACTION LIST
//           Expanded(
//             child: transactions.isEmpty
//                 ? const Center(child: Text("No transactions yet"))
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: transactions.length,
//                     itemBuilder: (context, index) {
//                       final t = transactions[index];
//                       final isGiven = t['type'] == 'GIVEN';
//                       final DateTime d =
//                           DateTime.tryParse(t['time'] ?? "") ?? DateTime.now();
//                       final note = t['note'] ?? "";

//                       return Align(
//                         alignment: isGiven
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           padding: const EdgeInsets.all(12),
//                           constraints: const BoxConstraints(maxWidth: 260),
//                           decoration: BoxDecoration(
//                             color: isGiven
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     isGiven
//                                         ? Icons.arrow_upward
//                                         : Icons.arrow_downward,
//                                     size: 16,
//                                     color: isGiven ? Colors.red : Colors.green,
//                                   ),
//                                   const SizedBox(width: 6),
//                                   Text(
//                                     "₹${t['amount']}",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: isGiven
//                                           ? Colors.red
//                                           : Colors.green,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               if (note.isNotEmpty) ...[
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   note,
//                                   style: const TextStyle(fontSize: 13),
//                                 ),
//                               ],
//                               const SizedBox(height: 6),
//                               Text(
//                                 "${d.day}/${d.month}/${d.year}  ${d.hour}:${d.minute.toString().padLeft(2, '0')}",
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           /// BOTTOM BUTTONS
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(false),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green.shade100,
//                       foregroundColor: Colors.green,
//                     ),
//                     child: const Text("Received"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(true),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red.shade100,
//                       foregroundColor: Colors.red,
//                     ),
//                     child: const Text("Given"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'add_transaction_screen.dart';
// import '../../account/screens/customer_profile_screen.dart';
// import '../../account/screens/customer_sms_settings_screen.dart';

// class CustomerDetailScreen extends StatefulWidget {
//   final String customerName;

//   const CustomerDetailScreen({super.key, required this.customerName});

//   @override
//   State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
// }

// class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
//   double calculateBalance(List transactions) {
//     double b = 0;
//     for (var t in transactions) {
//       if (t['type'] == 'GIVEN') {
//         b += t['amount'];
//       } else {
//         b -= t['amount'];
//       }
//     }
//     return b;
//   }

//   void openTransaction(bool isGiven) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddTransactionScreen(
//           isGiven: isGiven,
//           customerName: widget.customerName,
//         ),
//       ),
//     );

//     if (result != null) {
//       Provider.of<CustomerProvider>(
//         context,
//         listen: false,
//       ).addTransaction(widget.customerName, result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final transactions = provider.getTransactions(widget.customerName);
//     final customer = provider.getCustomerByName(widget.customerName);
//     final balance = calculateBalance(transactions);
//     final isDue = balance > 0;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(widget.customerName),
//         actions: [
//           /// ⭐ PROFILE BUTTON (FIXED)
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               Navigator.of(context).push(
//                 PageRouteBuilder(
//                   opaque: true,
//                   barrierDismissible: false,
//                   pageBuilder: (_, __, ___) =>
//                       CustomerProfileScreen(customerName: widget.customerName),
//                   transitionsBuilder: (_, animation, __, child) {
//                     return FadeTransition(opacity: animation, child: child);
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Text(
//                   widget.customerName,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "₹${balance.abs().toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   isDue ? "Due" : "Advance",
//                   style: TextStyle(
//                     color: isDue ? Colors.red : Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 6),

//           Expanded(
//             child: transactions.isEmpty
//                 ? const Center(child: Text("No transactions yet"))
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: transactions.length,
//                     itemBuilder: (context, index) {
//                       final t = transactions[index];
//                       final isGiven = t['type'] == 'GIVEN';
//                       final DateTime d =
//                           DateTime.tryParse(t['time'] ?? "") ?? DateTime.now();

//                       return Align(
//                         alignment: isGiven
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           padding: const EdgeInsets.all(12),
//                           constraints: const BoxConstraints(maxWidth: 260),
//                           decoration: BoxDecoration(
//                             color: isGiven
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "₹${t['amount']}",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: isGiven ? Colors.red : Colors.green,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 "${d.day}/${d.month}/${d.year}",
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(false),
//                     child: const Text("Received"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(true),
//                     child: const Text("Given"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'add_transaction_screen.dart';
// import '../../account/screens/customer_profile_screen.dart';

// class CustomerDetailScreen extends StatefulWidget {
//   final String customerName;

//   const CustomerDetailScreen({super.key, required this.customerName});

//   @override
//   State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
// }

// class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
//   double calculateBalance(List transactions) {
//     double b = 0;
//     for (var t in transactions) {
//       if (t['type'] == 'GIVEN') {
//         b += t['amount'];
//       } else {
//         b -= t['amount'];
//       }
//     }
//     return b;
//   }

//   void openTransaction(bool isGiven) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddTransactionScreen(
//           isGiven: isGiven,
//           customerName: widget.customerName,
//         ),
//       ),
//     );

//     if (result != null) {
//       Provider.of<CustomerProvider>(
//         context,
//         listen: false,
//       ).addTransaction(widget.customerName, result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final transactions = provider.getTransactions(widget.customerName);
//     final balance = calculateBalance(transactions);
//     final isDue = balance > 0;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(widget.customerName),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               print("PROFILE BUTTON CLICKED");

//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       CustomerProfileScreen(customerName: widget.customerName),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Text(
//                   widget.customerName,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "₹${balance.abs().toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   isDue ? "Due" : "Advance",
//                   style: TextStyle(
//                     color: isDue ? Colors.red : Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 6),

//           Expanded(
//             child: transactions.isEmpty
//                 ? const Center(child: Text("No transactions yet"))
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: transactions.length,
//                     itemBuilder: (context, index) {
//                       final t = transactions[index];
//                       final isGiven = t['type'] == 'GIVEN';
//                       final DateTime d =
//                           DateTime.tryParse(t['time'] ?? "") ?? DateTime.now();

//                       return Align(
//                         alignment: isGiven
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           padding: const EdgeInsets.all(12),
//                           constraints: const BoxConstraints(maxWidth: 260),
//                           decoration: BoxDecoration(
//                             color: isGiven
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "₹${t['amount']}",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: isGiven ? Colors.red : Colors.green,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 "${d.day}/${d.month}/${d.year}",
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(false),
//                     child: const Text("Received"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(true),
//                     child: const Text("Given"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'add_transaction_screen.dart';
// import '../../customer/screens/customer_sms_settings_screen.dart';

// class CustomerDetailScreen extends StatefulWidget {
//   final String customerName;

//   const CustomerDetailScreen({super.key, required this.customerName});

//   @override
//   State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
// }

// class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
//   double calculateBalance(List transactions) {
//     double b = 0;
//     for (var t in transactions) {
//       if (t['type'] == 'GIVEN') {
//         b += t['amount'];
//       } else {
//         b -= t['amount'];
//       }
//     }
//     return b;
//   }

//   void openTransaction(bool isGiven) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddTransactionScreen(
//           isGiven: isGiven,
//           customerName: widget.customerName,
//         ),
//       ),
//     );

//     if (result != null) {
//       Provider.of<CustomerProvider>(
//         context,
//         listen: false,
//       ).addTransaction(widget.customerName, result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final transactions = provider.getTransactions(widget.customerName);
//     final balance = calculateBalance(transactions);
//     final isDue = balance > 0;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(widget.customerName),
//         actions: [
//           /// ⭐ NOW OPENS SMS SETTINGS DIRECTLY
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               print("OPEN SMS SETTINGS");

//               Navigator.of(context, rootNavigator: true).push(
//                 MaterialPageRoute(
//                   builder: (_) => CustomerSmsSettingsScreen(
//                     customerName: widget.customerName,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),

//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Text(
//                   widget.customerName,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "₹${balance.abs().toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   isDue ? "Due" : "Advance",
//                   style: TextStyle(
//                     color: isDue ? Colors.red : Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 6),

//           Expanded(
//             child: transactions.isEmpty
//                 ? const Center(child: Text("No transactions yet"))
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: transactions.length,
//                     itemBuilder: (context, index) {
//                       final t = transactions[index];
//                       final isGiven = t['type'] == 'GIVEN';
//                       final DateTime d =
//                           DateTime.tryParse(t['time'] ?? "") ?? DateTime.now();

//                       return Align(
//                         alignment: isGiven
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           padding: const EdgeInsets.all(12),
//                           constraints: const BoxConstraints(maxWidth: 260),
//                           decoration: BoxDecoration(
//                             color: isGiven
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "₹${t['amount']}",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: isGiven ? Colors.red : Colors.green,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 "${d.day}/${d.month}/${d.year}",
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(false),
//                     child: const Text("Received"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(true),
//                     child: const Text("Given"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//// main code hai bhai ye /////

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'add_transaction_screen.dart';

// import 'customer_profile_screen.dart';

// class CustomerDetailScreen extends StatefulWidget {
//   final String customerName;

//   const CustomerDetailScreen({super.key, required this.customerName});

//   @override
//   State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
// }

// class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
//   double calculateBalance(List transactions) {
//     double b = 0;
//     for (var t in transactions) {
//       if (t['type'] == 'GIVEN') {
//         b += t['amount'];
//       } else {
//         b -= t['amount'];
//       }
//     }
//     return b;
//   }

//   void openTransaction(bool isGiven) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddTransactionScreen(
//           isGiven: isGiven,
//           customerName: widget.customerName,
//         ),
//       ),
//     );

//     if (result != null) {
//       Provider.of<CustomerProvider>(
//         context,
//         listen: false,
//       ).addTransaction(widget.customerName, result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final transactions = provider.getTransactions(widget.customerName);
//     final balance = calculateBalance(transactions);
//     final isDue = balance > 0;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,

//       appBar: AppBar(
//         leading: const BackButton(),
//         titleSpacing: 0,
//         title: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) =>
//                     CustomerProfileScreen(customerName: widget.customerName),
//               ),
//             );
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(widget.customerName, style: const TextStyle(fontSize: 18)),
//               const Text(
//                 "View Profile",
//                 style: TextStyle(fontSize: 13, color: Colors.green),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Text(
//                   widget.customerName,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "₹${balance.abs().toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   isDue ? "Due" : "Advance",
//                   style: TextStyle(
//                     color: isDue ? Colors.red : Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 6),

//           Expanded(
//             child: transactions.isEmpty
//                 ? const Center(child: Text("No transactions yet"))
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: transactions.length,
//                     itemBuilder: (context, index) {
//                       final t = transactions[index];
//                       final isGiven = t['type'] == 'GIVEN';
//                       final DateTime d =
//                           DateTime.tryParse(t['time'] ?? "") ?? DateTime.now();

//                       return Align(
//                         alignment: isGiven
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           padding: const EdgeInsets.all(12),
//                           constraints: const BoxConstraints(maxWidth: 260),
//                           decoration: BoxDecoration(
//                             color: isGiven
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "₹${t['amount']}",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: isGiven ? Colors.red : Colors.green,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 "${d.day}/${d.month}/${d.year}",
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(false),
//                     child: const Text("Received"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => openTransaction(true),
//                     child: const Text("Given"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // try code bhai ////
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'add_transaction_screen.dart';
// import 'customer_profile_screen.dart';

// class CustomerDetailScreen extends StatefulWidget {
//   final String customerName;
//   const CustomerDetailScreen({super.key, required this.customerName});

//   @override
//   State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
// }

// class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
//   double calculateBalance(List transactions) {
//     double b = 0;
//     for (var t in transactions) {
//       if (t['type'] == 'GIVEN') {
//         b += t['amount'];
//       } else {
//         b -= t['amount'];
//       }
//     }
//     return b;
//   }

//   void openTransaction(bool isGiven) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddTransactionScreen(
//           isGiven: isGiven,
//           customerName: widget.customerName,
//         ),
//       ),
//     );

//     if (result != null) {
//       Provider.of<CustomerProvider>(
//         context,
//         listen: false,
//       ).addTransaction(widget.customerName, result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final transactions = provider.getTransactions(widget.customerName);
//     final balance = calculateBalance(transactions);
//     final isDue = balance > 0;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,

//       /// 🔥 APPBAR UPDATED
//       appBar: AppBar(
//         leading: const BackButton(),
//         titleSpacing: 0,
//         title: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) =>
//                     CustomerProfileScreen(customerName: widget.customerName),
//               ),
//             );
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(widget.customerName, style: const TextStyle(fontSize: 18)),
//               const Text(
//                 "View Profile",
//                 style: TextStyle(fontSize: 13, color: Colors.green),
//               ),
//             ],
//           ),
//         ),
//         actions: const [
//           Icon(Icons.receipt_long),
//           SizedBox(width: 14),
//           Icon(Icons.call),
//           SizedBox(width: 10),
//         ],
//       ),

//       body: Column(
//         children: [
//           /// BALANCE TOP CARD (same tera)
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Text(
//                   widget.customerName,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "₹${balance.abs().toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   isDue ? "Due" : "Advance",
//                   style: TextStyle(
//                     color: isDue ? Colors.red : Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 6),

//           /// TRANSACTION LIST (same tera)
//           Expanded(
//             child: transactions.isEmpty
//                 ? const Center(child: Text("No transactions yet"))
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: transactions.length,
//                     itemBuilder: (context, index) {
//                       final t = transactions[index];
//                       final isGiven = t['type'] == 'GIVEN';
//                       final DateTime d =
//                           DateTime.tryParse(t['time'] ?? "") ?? DateTime.now();

//                       return Align(
//                         alignment: isGiven
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           padding: const EdgeInsets.all(12),
//                           constraints: const BoxConstraints(maxWidth: 260),
//                           decoration: BoxDecoration(
//                             color: isGiven
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "₹${t['amount']}",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: isGiven ? Colors.red : Colors.green,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 "${d.day}/${d.month}/${d.year}",
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           /// 🔥 KHATABOOK BOTTOM PANEL ADDED
//           Container(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.teal.shade200,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Icon(Icons.description, color: Colors.white),
//                       Icon(Icons.chat_bubble, color: Colors.white),
//                       Icon(Icons.call, color: Colors.white),
//                       Icon(Icons.message, color: Colors.white),
//                       Text("More  •••", style: TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Row(
//                       children: [
//                         Icon(Icons.calendar_today, size: 18),
//                         SizedBox(width: 8),
//                         Text("Set Due Date"),
//                       ],
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                       ),
//                       icon: const Icon(Icons.settings),
//                       label: const Text("Auto Reminder"),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 15),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("Balance Due"),
//                     Text(
//                       "₹${balance.abs()}",
//                       style: const TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 15),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () => openTransaction(false),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green.shade100,
//                           foregroundColor: Colors.green,
//                         ),
//                         child: const Text("Received"),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () => openTransaction(true),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red.shade100,
//                           foregroundColor: Colors.red,
//                         ),
//                         child: const Text("Given"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//// main code bhai  ////

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'add_transaction_screen.dart';
import 'customer_profile_screen.dart';
import 'customer_presonal_statement_screen.dart';

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

  /// ⭐ MORE BOTTOM SHEET
  void _openMoreSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            children: const [
              _MoreItem(Icons.delete, "Delete", Colors.red),
              _MoreItem(Icons.block, "Defaulters", Colors.red),
              _MoreItem(Icons.help, "Help", Colors.teal),
              _MoreItem(Icons.description, "Report", Colors.purple),
              _MoreItem(Icons.settings, "Give Discount", Colors.pink),
              _MoreItem(Icons.notifications, "Auto Reminder", Colors.teal),
              _MoreItem(Icons.call, "Call", Colors.green),
              _MoreItem(Icons.sms, "SMS", Colors.blue),
              _MoreItem(Icons.message, "Whatsapp", Colors.green),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final transactions = provider.getTransactions(widget.customerName);
    final balance = calculateBalance(transactions);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// APPBAR
      appBar: AppBar(
        leading: const BackButton(),
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CustomerProfileScreen(customerName: widget.customerName),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.customerName, style: const TextStyle(fontSize: 18)),
              const Text(
                "View Profile",
                style: TextStyle(fontSize: 13, color: Colors.green),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerStatementScreen(
                    customerName: widget.customerName,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          const Icon(Icons.call),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text("No transactions yet"))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      final isGiven = t['type'] == 'GIVEN';
                      final DateTime d =
                          DateTime.tryParse(t['time'] ?? "") ?? DateTime.now();

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
                              Text(
                                "₹${t['amount']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isGiven ? Colors.red : Colors.green,
                                  fontSize: 16,
                                ),
                              ),

                              /// ⭐⭐⭐ NOTE SHOW KARNA ⭐⭐⭐
                              if (t["note"] != null &&
                                  t["note"].toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    t["note"],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 6),

                              Text(
                                "${d.day}/${d.month}/${d.year}",
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

          /// KHATABOOK BOTTOM PANEL
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.description, color: Colors.white),
                      const Icon(Icons.chat_bubble, color: Colors.white),
                      const Icon(Icons.call, color: Colors.white),
                      const Icon(Icons.message, color: Colors.white),
                      GestureDetector(
                        onTap: _openMoreSheet,
                        child: const Text(
                          "More  •••",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18),
                        SizedBox(width: 8),
                        Text("Set Due Date"),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: const Icon(Icons.settings),
                      label: const Text("Auto Reminder"),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Balance Due"),
                    Text(
                      "₹${balance.abs()}",
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
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
                    const SizedBox(width: 10),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// MORE GRID ITEM
class _MoreItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  const _MoreItem(this.icon, this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(title, textAlign: TextAlign.center),
      ],
    );
  }
}
