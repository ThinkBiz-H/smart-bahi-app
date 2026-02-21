// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';

// class AccountStatementScreen extends StatelessWidget {
//   const AccountStatementScreen({super.key});
//   String _formatTime(String? time) {
//     if (time == null) return "";

//     final dt = DateTime.tryParse(time);
//     if (dt == null) return "";

//     final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
//     final minute = dt.minute.toString().padLeft(2, '0');
//     final period = dt.hour >= 12 ? "PM" : "AM";

//     return "$hour:$minute $period";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final customers = provider.customers;

//     /// ⭐ ALL TRANSACTIONS MERGE
//     List<Map<String, dynamic>> allTx = [];

//     for (var c in customers) {
//       for (var tx in c.transactions) {
//         allTx.add({
//           "name": c.name,
//           "amount": tx["amount"],
//           "type": tx["type"],
//           "time": tx["time"], // ⭐ YE ADD KARO
//         });
//       }
//     }

//     /// CALCULATIONS
//     double totalCredit = 0;
//     double totalPayment = 0;

//     for (var tx in allTx) {
//       if (tx["type"] == "GIVEN") {
//         totalCredit += tx["amount"];
//       } else {
//         totalPayment += tx["amount"];
//       }
//     }

//     double netBalance = totalCredit - totalPayment;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Account Statement")),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),

//           /// DATE CHIP
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.calendar_today, size: 16),
//                 SizedBox(width: 6),
//                 Text("Today"),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// TOP CARD
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Column(
//               children: [
//                 const Text("Net Balance"),
//                 Text(
//                   "₹${netBalance.toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 28,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_downward, color: Colors.green),
//                         Text(
//                           "₹${totalPayment.toStringAsFixed(0)}",
//                           style: const TextStyle(
//                             color: Colors.green,
//                             fontSize: 18,
//                           ),
//                         ),
//                         const Text("Payments"),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_upward, color: Colors.red),
//                         Text(
//                           "₹${totalCredit.toStringAsFixed(0)}",
//                           style: const TextStyle(
//                             color: Colors.red,
//                             fontSize: 18,
//                           ),
//                         ),
//                         const Text("Credits"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// TIMELINE LIST
//           Expanded(
//             child: ListView.builder(
//               itemCount: allTx.length,
//               itemBuilder: (context, index) {
//                 final tx = allTx[index];
//                 bool isCredit = tx["type"] == "GIVEN";

//                 return Align(
//                   alignment: isCredit
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isCredit
//                           ? Colors.red.shade50
//                           : Colors.green.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(tx["name"]),
//                         Text(
//                           "₹${tx["amount"]}",
//                           style: TextStyle(
//                             color: isCredit ? Colors.red : Colors.green,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           tx["time"] != null
//                               ? _formatTime(tx["time"])
//                               : "No Time",
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }       main screen

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';

// enum DateFilter { today, week, month }

// class AccountStatementScreen extends StatefulWidget {
//   const AccountStatementScreen({super.key});

//   @override
//   State<AccountStatementScreen> createState() => _AccountStatementScreenState();
// }

// class _AccountStatementScreenState extends State<AccountStatementScreen> {
//   DateFilter selectedFilter = DateFilter.today;

//   /// 🕒 time format
//   String _formatTime(String? time) {
//     if (time == null) return "";
//     final dt = DateTime.tryParse(time);
//     if (dt == null) return "";

//     final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
//     final minute = dt.minute.toString().padLeft(2, '0');
//     final period = dt.hour >= 12 ? "PM" : "AM";

//     return "$hour:$minute $period";
//   }

//   /// 📅 Filter logic
//   bool _isInFilter(DateTime date) {
//     final now = DateTime.now();

//     if (selectedFilter == DateFilter.today) {
//       return date.year == now.year &&
//           date.month == now.month &&
//           date.day == now.day;
//     }

//     if (selectedFilter == DateFilter.week) {
//       final weekAgo = now.subtract(const Duration(days: 7));
//       return date.isAfter(weekAgo);
//     }

//     if (selectedFilter == DateFilter.month) {
//       return date.year == now.year && date.month == now.month;
//     }

//     return true;
//   }

//   /// 🟢 Filter chip widget (NOW INSIDE CLASS)
//   Widget _filterChip(String text, DateFilter filter) {
//     final isSelected = selectedFilter == filter;

//     return GestureDetector(
//       onTap: () => setState(() => selectedFilter = filter),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.green : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final customers = provider.customers;

//     /// 🔥 MERGE + FILTER ALL TRANSACTIONS
//     List<Map<String, dynamic>> allTx = [];

//     for (var c in customers) {
//       for (var tx in c.transactions) {
//         final DateTime time =
//             DateTime.tryParse(tx["time"] ?? "") ?? DateTime.now();

//         if (_isInFilter(time)) {
//           allTx.add({
//             "name": c.name,
//             "amount": tx["amount"],
//             "type": tx["type"],
//             "time": tx["time"],
//           });
//         }
//       }
//     }

//     /// 💰 CALCULATIONS
//     double totalCredit = 0;
//     double totalPayment = 0;

//     for (var tx in allTx) {
//       if (tx["type"] == "GIVEN") {
//         totalCredit += tx["amount"];
//       } else {
//         totalPayment += tx["amount"];
//       }
//     }

//     double netBalance = totalCredit - totalPayment;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Account Statement")),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),

//           /// 🔘 FILTER TABS
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _filterChip("Today", DateFilter.today),
//               const SizedBox(width: 8),
//               _filterChip("Week", DateFilter.week),
//               const SizedBox(width: 8),
//               _filterChip("Month", DateFilter.month),
//             ],
//           ),

//           const SizedBox(height: 10),

//           /// 📊 TOP CARD
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Column(
//               children: [
//                 const Text("Net Balance"),
//                 Text(
//                   "₹${netBalance.toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 28,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_downward, color: Colors.green),
//                         Text(
//                           "₹${totalPayment.toStringAsFixed(0)}",
//                           style: const TextStyle(color: Colors.green),
//                         ),
//                         const Text("Payments"),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_upward, color: Colors.red),
//                         Text(
//                           "₹${totalCredit.toStringAsFixed(0)}",
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                         const Text("Credits"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// 📜 TIMELINE
//           Expanded(
//             child: ListView.builder(
//               itemCount: allTx.length,
//               itemBuilder: (context, index) {
//                 final tx = allTx[index];
//                 bool isCredit = tx["type"] == "GIVEN";

//                 return Align(
//                   alignment: isCredit
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isCredit
//                           ? Colors.red.shade50
//                           : Colors.green.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(tx["name"]),
//                         Text(
//                           "₹${tx["amount"]}",
//                           style: TextStyle(
//                             color: isCredit ? Colors.red : Colors.green,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           _formatTime(tx["time"]),
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//                  try screen  ///////

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import '../screens/date_range_screen.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:intl/intl.dart';

// class AccountStatementScreen extends StatefulWidget {
//   const AccountStatementScreen({super.key});

//   @override
//   State<AccountStatementScreen> createState() => _AccountStatementScreenState();
// }

// class _AccountStatementScreenState extends State<AccountStatementScreen> {
//   DateTime? startDate;
//   DateTime? endDate;

//   /// 🕒 time format
//   String _formatTime(String? time) {
//     if (time == null) return "";
//     final dt = DateTime.tryParse(time);
//     if (dt == null) return "";

//     final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
//     final minute = dt.minute.toString().padLeft(2, '0');
//     final period = dt.hour >= 12 ? "PM" : "AM";

//     return "$hour:$minute $period";
//   }

//   /// 📅 RANGE FILTER (MOST IMPORTANT)
//   bool _isInRange(DateTime date) {
//     final now = DateTime.now();

//     /// Default → TODAY
//     if (startDate == null || endDate == null) {
//       return date.year == now.year &&
//           date.month == now.month &&
//           date.day == now.day;
//     }

//     /// Selected range
//     return date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
//         date.isBefore(endDate!.add(const Duration(days: 1)));
//   }

//   /// 📅 CHIP TEXT
//   String get dateText {
//     if (startDate == null) return "Today";

//     return "${startDate!.day}/${startDate!.month}/${startDate!.year} - "
//         "${endDate!.day}/${endDate!.month}/${endDate!.year}";
//   }

//   Future<void> _downloadPdf(List<Map<String, dynamic>> allTx) async {
//     final pdf = pw.Document();

//     final formatter = DateFormat("dd MMM yyyy");

//     pdf.addPage(
//       pw.MultiPage(
//         build: (context) => [
//           pw.Text(
//             "Account Statement",
//             style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text(
//             startDate == null
//                 ? "Today"
//                 : "${formatter.format(startDate!)} - ${formatter.format(endDate!)}",
//           ),
//           pw.SizedBox(height: 20),

//           pw.Table.fromTextArray(
//             headers: ["Name", "Type", "Amount", "Time"],
//             data: allTx.map((tx) {
//               return [
//                 tx["name"],
//                 tx["type"],
//                 "₹${tx["amount"]}",
//                 _formatTime(tx["time"]),
//               ];
//             }).toList(),
//           ),
//         ],
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final customers = provider.customers;

//     /// 🔥 MERGE + FILTER ALL TRANSACTIONS
//     List<Map<String, dynamic>> allTx = [];

//     for (var c in customers) {
//       for (var tx in c.transactions) {
//         final DateTime time =
//             DateTime.tryParse(tx["time"] ?? "") ?? DateTime.now();

//         if (_isInRange(time)) {
//           allTx.add({
//             "name": c.name,
//             "amount": tx["amount"],
//             "type": tx["type"],
//             "time": tx["time"],
//           });
//         }
//       }
//     }

//     /// 💰 CALCULATIONS
//     double totalCredit = 0;
//     double totalPayment = 0;

//     for (var tx in allTx) {
//       if (tx["type"] == "GIVEN") {
//         totalCredit += tx["amount"];
//       } else {
//         totalPayment += tx["amount"];
//       }
//     }

//     double netBalance = totalCredit - totalPayment;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Account Statement")),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),

//           /// ⭐ DATE CHIP (CLICKABLE)
//           GestureDetector(
//             onTap: () async {
//               final result = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       DateRangeScreen(startDate: startDate, endDate: endDate),
//                 ),
//               );

//               if (result != null) {
//                 setState(() {
//                   startDate = result["start"];
//                   endDate = result["end"];
//                 });
//               }
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(color: Colors.green),
//                 color: Colors.green.shade50,
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.calendar_today,
//                     size: 18,
//                     color: Colors.green,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     dateText,
//                     style: const TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   const Icon(Icons.keyboard_arrow_down, color: Colors.green),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// 📊 TOP CARD
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Column(
//               children: [
//                 const Text("Net Balance"),
//                 Text(
//                   "₹${netBalance.toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 28,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_downward, color: Colors.green),
//                         Text(
//                           "₹${totalPayment.toStringAsFixed(0)}",
//                           style: const TextStyle(color: Colors.green),
//                         ),
//                         const Text("Payments"),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_upward, color: Colors.red),
//                         Text(
//                           "₹${totalCredit.toStringAsFixed(0)}",
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                         const Text("Credits"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// 📜 TRANSACTION LIST
//           Expanded(
//             child: allTx.isEmpty
//                 ? const Center(child: Text("No transactions"))
//                 : ListView.builder(
//                     itemCount: allTx.length,
//                     itemBuilder: (context, index) {
//                       final tx = allTx[index];
//                       bool isCredit = tx["type"] == "GIVEN";

//                       return Align(
//                         alignment: isCredit
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: isCredit
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(tx["name"]),
//                               Text(
//                                 "₹${tx["amount"]}",
//                                 style: TextStyle(
//                                   color: isCredit ? Colors.red : Colors.green,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 _formatTime(tx["time"]),
//                                 style: const TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// // }
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/google_fonts.dart';
// import 'package:pdf/pdf.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import '../screens/date_range_screen.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:intl/intl.dart';

// class AccountStatementScreen extends StatefulWidget {
//   const AccountStatementScreen({super.key});

//   @override
//   State<AccountStatementScreen> createState() => _AccountStatementScreenState();
// }

// class _AccountStatementScreenState extends State<AccountStatementScreen> {
//   DateTime? startDate;
//   DateTime? endDate;

//   /// TIME FORMAT
//   String _formatTime(String? time) {
//     if (time == null) return "";
//     final dt = DateTime.tryParse(time);
//     if (dt == null) return "";

//     final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
//     final minute = dt.minute.toString().padLeft(2, '0');
//     final period = dt.hour >= 12 ? "PM" : "AM";
//     return "$hour:$minute $period";
//   }

//   /// DATE RANGE FILTER
//   bool _isInRange(DateTime date) {
//     final now = DateTime.now();

//     /// Default = TODAY
//     if (startDate == null || endDate == null) {
//       return date.year == now.year &&
//           date.month == now.month &&
//           date.day == now.day;
//     }

//     /// Custom Range
//     return date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
//         date.isBefore(endDate!.add(const Duration(days: 1)));
//   }

//   /// CHIP TEXT
//   String get dateText {
//     if (startDate == null) return "Today";

//     return "${startDate!.day}/${startDate!.month}/${startDate!.year} - "
//         "${endDate!.day}/${endDate!.month}/${endDate!.year}";
//   }

//   /// 🔥 OKCREDIT STYLE PDF
//   Future<void> _downloadPdf(
//     final font = await PdfGoogleFonts.notoSansRegular();
//     List<Map<String, dynamic>> allTx,
//     double totalPayment,
//     double totalCredit,
//     double netBalance,
//   ) async {
//     final pdf = pw.Document();
//     final formatter = DateFormat("dd MMM yyyy");

//     String rangeText = startDate == null
//         ? "Today"
//         : "${formatter.format(startDate!)} - ${formatter.format(endDate!)}";

//     pdf.addPage(
//       pw.Page(
//         build: (context) {
//           return pw.Container(
//             color: PdfColors.grey100,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 /// HEADER
//                 pw.Container(
//                   width: double.infinity,
//                   padding: const pw.EdgeInsets.all(16),
//                   color: PdfColors.green,
//                   child: pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text(
//                         "OKCREDIT",
//                         style: pw.TextStyle(
//                           color: PdfColors.white,
//                           fontSize: 22,
//                           fontWeight: pw.FontWeight.bold,
//                           font: font,
//                         ),
//                       ),
//                       pw.Text(
//                         "7852865819",
//                         style: const pw.TextStyle(color: PdfColors.white),
//                       ),
//                     ],
//                   ),
//                 ),

//                 pw.SizedBox(height: 20),

//                 pw.Center(
//                   child: pw.Text(
//                     "ACCOUNT STATEMENT",
//                     style: pw.TextStyle(
//                       fontSize: 16,
//                       fontWeight: pw.FontWeight.bold,
//                       font: font,
//                     ),
//                   ),
//                 ),
//                 pw.SizedBox(height: 6),
//                 pw.Center(child: pw.Text(rangeText)),

//                 pw.SizedBox(height: 20),

//                 /// BALANCE CARD
//                 pw.Container(
//                   padding: const pw.EdgeInsets.all(16),
//                   decoration: pw.BoxDecoration(
//                     borderRadius: pw.BorderRadius.circular(12),
//                     border: pw.Border.all(color: PdfColors.grey300),
//                     color: PdfColors.white,
//                   ),
//                   child: pw.Column(
//                     children: [
//                       pw.Text("NET BALANCE"),
//                       pw.Text(
//                         "₹ ${netBalance.toStringAsFixed(0)}",
//                         style: pw.TextStyle(
//                           fontSize: 26,
//                           color: PdfColors.red,
//                           fontWeight: pw.FontWeight.bold,
//                           font: font,
//                         ),
//                       ),
//                       pw.SizedBox(height: 10),
//                       pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
//                         children: [
//                           pw.Column(
//                             children: [
//                               pw.Text("PAYMENTS"),
//                               pw.Text(
//                                 "₹ ${totalPayment.toStringAsFixed(0)}",
//                                 style: pw.TextStyle(color: PdfColors.green),
//                               ),
//                             ],
//                           ),
//                           pw.Column(
//                             children: [
//                               pw.Text("CREDITS"),
//                               pw.Text(
//                                 "₹ ${totalCredit.toStringAsFixed(0)}",
//                                 style: pw.TextStyle(color: PdfColors.red),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 pw.SizedBox(height: 20),

//                 /// TABLE HEADER
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Text("DATE"),
//                     pw.Text("CUSTOMER"),
//                     pw.Text("PAYMENT"),
//                     pw.Text("CREDIT"),
//                   ],
//                 ),
//                 pw.Divider(),

//                 /// TRANSACTION LIST
//                 ...allTx.map((tx) {
//                   final dt = DateTime.tryParse(tx["time"]);
//                   final date = DateFormat("dd MMM").format(dt!);
//                   final isCredit = tx["type"] == "GIVEN";

//                   return pw.Padding(
//                     padding: const pw.EdgeInsets.symmetric(vertical: 6),
//                     child: pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text(date),
//                         pw.Text(tx["name"]),
//                         pw.Text(isCredit ? "" : "₹${tx["amount"]}"),
//                         pw.Text(isCredit ? "₹${tx["amount"]}" : ""),
//                       ],
//                     ),
//                   );
//                 }),

//                 pw.Spacer(),
//                 pw.Center(
//                   child: pw.Text(
//                     "Generated by OkCredit",
//                     style: pw.TextStyle(color: PdfColors.green),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final customers = provider.customers;

//     /// MERGE + FILTER TX
//     List<Map<String, dynamic>> allTx = [];
//     for (var c in customers) {
//       for (var tx in c.transactions) {
//         final time = DateTime.tryParse(tx["time"] ?? "") ?? DateTime.now();
//         if (_isInRange(time)) {
//           allTx.add({
//             "name": c.name,
//             "amount": tx["amount"],
//             "type": tx["type"],
//             "time": tx["time"],
//           });
//         }
//       }
//     }

//     double totalCredit = 0;
//     double totalPayment = 0;
//     for (var tx in allTx) {
//       if (tx["type"] == "GIVEN") {
//         totalCredit += tx["amount"];
//       } else {
//         totalPayment += tx["amount"];
//       }
//     }
//     double netBalance = totalCredit - totalPayment;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Account Statement")),
//       body: Column(
//         children: [
//           const SizedBox(height: 12),

//           /// DATE CHIP
//           GestureDetector(
//             onTap: () async {
//               final result = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       DateRangeScreen(startDate: startDate, endDate: endDate),
//                 ),
//               );
//               if (result != null) {
//                 setState(() {
//                   startDate = result["start"];
//                   endDate = result["end"];
//                 });
//               }
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(color: Colors.green),
//                 color: Colors.green.shade50,
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.calendar_today, color: Colors.green),
//                   const SizedBox(width: 8),
//                   Text(
//                     dateText,
//                     style: const TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Icon(Icons.keyboard_arrow_down, color: Colors.green),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 12),

//           /// SUMMARY CARD
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Column(
//               children: [
//                 const Text("Net Balance"),
//                 Text(
//                   "₹${netBalance.toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 28,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_downward, color: Colors.green),
//                         Text(
//                           "₹${totalPayment.toStringAsFixed(0)}",
//                           style: const TextStyle(color: Colors.green),
//                         ),
//                         const Text("Payments"),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_upward, color: Colors.red),
//                         Text(
//                           "₹${totalCredit.toStringAsFixed(0)}",
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                         const Text("Credits"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// LIST
//           Expanded(
//             child: ListView.builder(
//               itemCount: allTx.length,
//               itemBuilder: (context, index) {
//                 final tx = allTx[index];
//                 bool isCredit = tx["type"] == "GIVEN";

//                 return Align(
//                   alignment: isCredit
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isCredit
//                           ? Colors.red.shade50
//                           : Colors.green.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(tx["name"]),
//                         Text(
//                           "₹${tx["amount"]}",
//                           style: TextStyle(
//                             color: isCredit ? Colors.red : Colors.green,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           _formatTime(tx["time"]),
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           /// DOWNLOAD BUTTON
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               onPressed: () =>
//                   _downloadPdf(allTx, totalPayment, totalCredit, netBalance),
//               icon: const Icon(Icons.download),
//               label: const Text(
//                 "Download",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:printing/printing.dart';

// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/google_fonts.dart';

// import '../../../providers/customer_provider.dart';
// import '../screens/date_range_screen.dart';

// class AccountStatementScreen extends StatefulWidget {
//   const AccountStatementScreen({super.key});

//   @override
//   State<AccountStatementScreen> createState() => _AccountStatementScreenState();
// }

// class _AccountStatementScreenState extends State<AccountStatementScreen> {
//   DateTime? startDate;
//   DateTime? endDate;

//   /// TIME FORMAT
//   String _formatTime(String? time) {
//     if (time == null) return "";
//     final dt = DateTime.tryParse(time);
//     if (dt == null) return "";
//     final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
//     final minute = dt.minute.toString().padLeft(2, '0');
//     final period = dt.hour >= 12 ? "PM" : "AM";
//     return "$hour:$minute $period";
//   }

//   /// DATE RANGE FILTER
//   bool _isInRange(DateTime date) {
//     final now = DateTime.now();

//     if (startDate == null || endDate == null) {
//       return date.year == now.year &&
//           date.month == now.month &&
//           date.day == now.day;
//     }

//     return date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
//         date.isBefore(endDate!.add(const Duration(days: 1)));
//   }

//   String get dateText {
//     if (startDate == null) return "Today";
//     return "${DateFormat("dd MMM yyyy").format(startDate!)} - "
//         "${DateFormat("dd MMM yyyy").format(endDate!)}";
//   }

//   // 🔥🔥🔥 OKCREDIT STYLE PDF (FINAL)
//   Future<void> _downloadPdf(
//     List<Map<String, dynamic>> allTx,
//     double totalPayment,
//     double totalCredit,
//     double netBalance,
//   ) async {
//     final pdf = pw.Document();
//     final font = await PdfGoogleFonts.notoSansRegular();
//     final formatter = DateFormat("dd MMM yyyy");

//     String rangeText = startDate == null
//         ? "Today"
//         : "${formatter.format(startDate!)} - ${formatter.format(endDate!)}";

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         build: (context) => [
//           /// HEADER
//           pw.Container(
//             padding: const pw.EdgeInsets.all(16),
//             color: PdfColors.green,
//             child: pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text(
//                   "OKCREDIT",
//                   style: pw.TextStyle(
//                     font: font,
//                     color: PdfColors.white,
//                     fontSize: 22,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.Text(
//                   "7852865819",
//                   style: pw.TextStyle(font: font, color: PdfColors.white),
//                 ),
//               ],
//             ),
//           ),

//           pw.SizedBox(height: 15),

//           pw.Center(
//             child: pw.Text(
//               "ACCOUNT STATEMENT",
//               style: pw.TextStyle(
//                 font: font,
//                 fontSize: 16,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//           ),

//           pw.SizedBox(height: 5),
//           pw.Center(
//             child: pw.Text(rangeText, style: pw.TextStyle(font: font)),
//           ),
//           pw.SizedBox(height: 20),

//           /// BALANCE CARD
//           pw.Container(
//             padding: const pw.EdgeInsets.all(16),
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(color: PdfColors.grey300),
//               borderRadius: pw.BorderRadius.circular(12),
//             ),
//             child: pw.Column(
//               children: [
//                 pw.Text("NET BALANCE", style: pw.TextStyle(font: font)),
//                 pw.SizedBox(height: 8),
//                 pw.Text(
//                   "₹ ${netBalance.toStringAsFixed(0)}",
//                   style: pw.TextStyle(
//                     font: font,
//                     fontSize: 26,
//                     color: PdfColors.red,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
//                   children: [
//                     pw.Column(
//                       children: [
//                         pw.Text("PAYMENTS", style: pw.TextStyle(font: font)),
//                         pw.Text(
//                           "₹ ${totalPayment.toStringAsFixed(0)}",
//                           style: pw.TextStyle(
//                             font: font,
//                             color: PdfColors.green,
//                           ),
//                         ),
//                       ],
//                     ),
//                     pw.Column(
//                       children: [
//                         pw.Text("CREDITS", style: pw.TextStyle(font: font)),
//                         pw.Text(
//                           "₹ ${totalCredit.toStringAsFixed(0)}",
//                           style: pw.TextStyle(font: font, color: PdfColors.red),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           pw.SizedBox(height: 25),

//           /// TABLE HEADER
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//               pw.Text("DATE", style: pw.TextStyle(font: font)),
//               pw.Text("CUSTOMER", style: pw.TextStyle(font: font)),
//               pw.Text("PAYMENT", style: pw.TextStyle(font: font)),
//               pw.Text("CREDIT", style: pw.TextStyle(font: font)),
//             ],
//           ),
//           pw.Divider(),

//           /// TRANSACTIONS
//           ...allTx.map((tx) {
//             final dt = DateTime.parse(tx["time"]);
//             final date = DateFormat("dd MMM").format(dt);
//             final isCredit = tx["type"] == "GIVEN";

//             return pw.Padding(
//               padding: const pw.EdgeInsets.symmetric(vertical: 6),
//               child: pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text(date, style: pw.TextStyle(font: font)),
//                   pw.Text(tx["name"], style: pw.TextStyle(font: font)),
//                   pw.Text(
//                     isCredit ? "" : "₹${tx["amount"]}",
//                     style: pw.TextStyle(font: font),
//                   ),
//                   pw.Text(
//                     isCredit ? "₹${tx["amount"]}" : "",
//                     style: pw.TextStyle(font: font),
//                   ),
//                 ],
//               ),
//             );
//           }),

//           pw.SizedBox(height: 30),
//           pw.Center(
//             child: pw.Text(
//               "Generated by OkCredit",
//               style: pw.TextStyle(font: font, color: PdfColors.green),
//             ),
//           ),
//         ],
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final customers = provider.customers;

//     List<Map<String, dynamic>> allTx = [];
//     for (var c in customers) {
//       for (var tx in c.transactions) {
//         final time = DateTime.tryParse(tx["time"] ?? "") ?? DateTime.now();
//         if (_isInRange(time)) {
//           allTx.add({
//             "name": c.name,
//             "amount": tx["amount"],
//             "type": tx["type"],
//             "time": tx["time"],
//           });
//         }
//       }
//     }

//     double totalCredit = 0;
//     double totalPayment = 0;
//     for (var tx in allTx) {
//       if (tx["type"] == "GIVEN") {
//         totalCredit += tx["amount"];
//       } else {
//         totalPayment += tx["amount"];
//       }
//     }
//     double netBalance = totalCredit - totalPayment;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Account Statement")),
//       body: Column(
//         children: [
//           const SizedBox(height: 12),

//           /// DATE CHIP
//           GestureDetector(
//             onTap: () async {
//               final result = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       DateRangeScreen(startDate: startDate, endDate: endDate),
//                 ),
//               );
//               if (result != null) {
//                 setState(() {
//                   startDate = result["start"];
//                   endDate = result["end"];
//                 });
//               }
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(color: Colors.green),
//                 color: Colors.green.shade50,
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.calendar_today, color: Colors.green),
//                   const SizedBox(width: 8),
//                   Text(
//                     dateText,
//                     style: const TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Icon(Icons.keyboard_arrow_down, color: Colors.green),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 12),

//           /// DOWNLOAD BUTTON
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               onPressed: () =>
//                   _downloadPdf(allTx, totalPayment, totalCredit, netBalance),
//               icon: const Icon(Icons.download),
//               label: const Text("Download Statement"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../providers/customer_provider.dart';
import '../screens/date_range_screen.dart';

class AccountStatementScreen extends StatefulWidget {
  const AccountStatementScreen({super.key});

  @override
  State<AccountStatementScreen> createState() => _AccountStatementScreenState();
}

class _AccountStatementScreenState extends State<AccountStatementScreen> {
  DateTime? startDate;
  DateTime? endDate;

  /// time format
  String formatTime(String? time) {
    if (time == null) return "";
    final dt = DateTime.tryParse(time);
    if (dt == null) return "";
    return DateFormat("hh:mm a").format(dt);
  }

  /// date format
  String formatDate(String? time) {
    if (time == null) return "";
    final dt = DateTime.tryParse(time);
    if (dt == null) return "";
    return DateFormat("dd MMM yyyy, hh:mm a").format(dt);
  }

  /// filter logic
  bool isInRange(DateTime date) {
    final now = DateTime.now();

    /// default = TODAY
    if (startDate == null || endDate == null) {
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }

    return date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
        date.isBefore(endDate!.add(const Duration(days: 1)));
  }

  String get dateText {
    if (startDate == null) return "Today";
    return "${DateFormat("dd MMM yyyy").format(startDate!)} - ${DateFormat("dd MMM yyyy").format(endDate!)}";
  }

  Future<void> _downloadPdf(
    List<Map<String, dynamic>> allTx,
    double totalPayment,
    double totalCredit,
    double netBalance,
  ) async {
    final pdf = pw.Document();
    final formatter = DateFormat("dd MMM yyyy");

    String rangeText = startDate == null
        ? "Today"
        : "${formatter.format(startDate!)} - ${formatter.format(endDate!)}";

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          /// HEADER (GREEN STRIP)
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            color: PdfColors.green,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "SmartBahi",
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  "7852865819",
                  style: const pw.TextStyle(color: PdfColors.white),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 15),

          /// TITLE
          pw.Center(
            child: pw.Text(
              "ACCOUNT STATEMENT",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ),

          pw.SizedBox(height: 5),
          pw.Center(child: pw.Text(rangeText)),
          pw.SizedBox(height: 20),

          /// NET BALANCE CARD
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Column(
              children: [
                pw.Text("NET BALANCE"),
                pw.SizedBox(height: 8),
                pw.Text(
                  netBalance.toStringAsFixed(0),
                  style: pw.TextStyle(
                    fontSize: 26,
                    color: PdfColors.red,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text("PAYMENTS"),
                        pw.Text(
                          totalPayment.toStringAsFixed(0),
                          style: pw.TextStyle(color: PdfColors.green),
                        ),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text("CREDITS"),
                        pw.Text(
                          totalCredit.toStringAsFixed(0),
                          style: pw.TextStyle(color: PdfColors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 25),

          /// TABLE HEADER
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("DATE"),
              pw.Text("CUSTOMER-NAME"),
              pw.Text("PAYMENT"),
              pw.Text("CREDIT"),
            ],
          ),
          pw.Divider(),

          /// TRANSACTION LIST
          /// TRANSACTION LIST WITH ROW DIVIDER
          ...allTx.map((tx) {
            final dt = DateTime.parse(tx["time"]);
            final date = DateFormat("dd MMM").format(dt);
            final isCredit = tx["type"] == "GIVEN";

            return pw.Column(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(date),
                      pw.Text(tx["name"]),
                      pw.Text(isCredit ? "" : tx["amount"].toString()),
                      pw.Text(isCredit ? tx["amount"].toString() : ""),
                    ],
                  ),
                ),

                /// 👇 THIS IS THE LINE YOU WANT
                pw.Divider(color: PdfColors.grey300, thickness: 1.0),
              ],
            );
          }),

          pw.SizedBox(height: 30),
          pw.Center(
            child: pw.Text(
              "Generated by SmartBahi",
              style: pw.TextStyle(color: PdfColors.green),
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final customers = provider.customers;

    /// 🔥 MERGE + FILTER ALL TX
    List<Map<String, dynamic>> allTx = [];

    for (var c in customers) {
      for (var tx in c.transactions) {
        final time = DateTime.tryParse(tx["time"] ?? "") ?? DateTime.now();
        if (isInRange(time)) {
          allTx.add({
            "name": c.name,
            "amount": tx["amount"],
            "type": tx["type"],
            "time": tx["time"],
          });
        }
      }
    }

    /// CALCULATIONS
    double totalCredit = 0;
    double totalPayment = 0;

    for (var tx in allTx) {
      if (tx["type"] == "GIVEN") {
        totalCredit += tx["amount"];
      } else {
        totalPayment += tx["amount"];
      }
    }

    double netBalance = totalCredit - totalPayment;

    return Scaffold(
      appBar: AppBar(title: const Text("Account Statement")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          /// 🔥 DATE CHIP (LIKE OKCREDIT)
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DateRangeScreen(startDate: startDate, endDate: endDate),
                ),
              );

              if (result != null) {
                setState(() {
                  startDate = result["start"];
                  endDate = result["end"];
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.green),
                color: Colors.green.shade50,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.calendar_today, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Today",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.green),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// 🔥 SUMMARY CARD (EXACT DESIGN)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xffe9f5ee),
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text("Net Balance"),
                    const Spacer(),
                    Text(
                      "₹${netBalance.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.arrow_downward, color: Colors.green),
                          Text(
                            "₹${totalPayment.toStringAsFixed(0)}",
                            style: const TextStyle(color: Colors.green),
                          ),
                          const Text("Payments"),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.arrow_upward, color: Colors.red),
                          Text(
                            "₹${totalCredit.toStringAsFixed(0)}",
                            style: const TextStyle(color: Colors.red),
                          ),
                          const Text("Credits"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// 🔥 TRANSACTION CHAT LIST (FINAL)
          Expanded(
            child: ListView.builder(
              itemCount: allTx.length,
              itemBuilder: (context, index) {
                final tx = allTx[index];
                bool isCredit = tx["type"] == "GIVEN";

                return Align(
                  alignment: isCredit
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "₹${tx["amount"]}",
                          style: TextStyle(
                            color: isCredit ? Colors.red : Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDate(tx["time"]),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// 🔥 BOTTOM DOWNLOAD BUTTON
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () =>
                  _downloadPdf(allTx, totalPayment, totalCredit, netBalance),
              icon: const Icon(Icons.download),
              label: const Text(
                "Download",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
