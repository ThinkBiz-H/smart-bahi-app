// import 'package:hive/hive.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import '../../../services/api_service.dart';
// import 'create_bill_screen.dart';

// class BillPreviewScreen extends StatefulWidget {
//   final String? billKey;

//   final List<Map<String, dynamic>> items;
//   final String customerName;
//   final String mobile;
//   final String address;
//   final String billNumber;
//   final DateTime billDate;

//   final double subTotal;
//   final double charges;
//   final double discount;
//   final double gstTotal;
//   final double cessTotal;
//   final double grandTotal;

//   const BillPreviewScreen({
//     super.key,
//     required this.billKey,
//     required this.items,
//     required this.customerName,
//     required this.mobile,
//     required this.address,
//     required this.billNumber,
//     required this.billDate,
//     required this.subTotal,
//     required this.charges,
//     required this.discount,
//     required this.gstTotal,
//     required this.cessTotal,
//     required this.grandTotal,
//   });

//   @override
//   State<BillPreviewScreen> createState() => _BillPreviewScreenState();
// }

// class _BillPreviewScreenState extends State<BillPreviewScreen> {
//   bool isPaid = false;
//   bool inventoryPopupShown = false;

//   /// ================= SAVE BILL =================

//   Future<void> saveBillWithoutNavigation() async {
//     try {
//       final provider = context.read<CustomerProvider>();

//       final settings = Hive.box('settings');
//       final ownerMobile = settings.get('mobile');

//       if (ownerMobile == null) {
//         debugPrint("❌ ownerMobile missing");
//         return;
//       }

//       final billData = {
//         "ownerMobile": ownerMobile,
//         "customerName": widget.customerName,
//         "mobile": widget.mobile,
//         "address": widget.address,
//         "billNumber": widget.billNumber,
//         "date": widget.billDate.toIso8601String(),
//         "items": widget.items,
//         "subTotal": widget.subTotal,
//         "gstTotal": widget.gstTotal,
//         "cessTotal": widget.cessTotal,
//         "charges": widget.charges,
//         "discount": widget.discount,
//         "grandTotal": widget.grandTotal,
//         "paid": isPaid,
//       };

//       debugPrint("📦 Bill Data: $billData");

//       if (widget.billKey != null) {
//         await ApiService.updateBill(widget.billKey!, billData);
//         debugPrint("✏️ Bill Updated");
//       } else {
//         await ApiService.addBill(billData);
//         debugPrint("✅ Bill Saved");
//       }

//       /// ADD TRANSACTION IF UNPAID

//       if (!isPaid) {
//         provider.addTransaction(widget.customerName, {
//           'amount': widget.grandTotal,
//           'note': 'Bill ${widget.billNumber}',
//           'date': DateTime.now(),
//           'type': 'GIVEN',
//         });
//       }
//     } catch (e) {
//       debugPrint("❌ Bill Save Error: $e");
//     }
//   }

//   Future<void> saveBill() async {
//     await saveBillWithoutNavigation();

//     if (!mounted) return;

//     Navigator.pop(context);
//     Navigator.pop(context);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(widget.billKey != null ? "Bill Updated" : "Bill Saved"),
//       ),
//     );
//   }

//   /// ================= INVENTORY POPUP =================

//   void showInventoryPopup() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircleAvatar(
//                 radius: 32,
//                 backgroundColor: Colors.green.shade100,
//                 child: const Icon(
//                   Icons.inventory_2,
//                   color: Colors.green,
//                   size: 30,
//                 ),
//               ),
//               const SizedBox(height: 15),

//               const Text(
//                 "Do you wish to add/update these items in inventory?",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),

//               const SizedBox(height: 20),

//               ...widget.items.map(
//                 (e) => Row(
//                   children: [
//                     Text(e['name']),
//                     const Spacer(),
//                     const Icon(Icons.check_box, color: Colors.green),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         inventoryPopupShown = true;
//                         Navigator.pop(context);
//                       },
//                       child: const Text("Cancel"),
//                     ),
//                   ),

//                   const SizedBox(width: 12),

//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                       ),

//                       onPressed: () async {
//                         inventoryPopupShown = true;

//                         Navigator.pop(context);

//                         await saveBillWithoutNavigation();

//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => CreateBillScreen(
//                               billKey: widget.billKey,
//                               existingBill: {
//                                 "customerName": widget.customerName,
//                                 "mobile": widget.mobile,
//                                 "address": widget.address,
//                                 "billNumber": widget.billNumber,
//                                 "date": widget.billDate.toIso8601String(),
//                                 "items": widget.items,
//                                 "subTotal": widget.subTotal,
//                                 "gstTotal": widget.gstTotal,
//                                 "cessTotal": widget.cessTotal,
//                                 "charges": widget.charges,
//                                 "discount": widget.discount,
//                                 "grandTotal": widget.grandTotal,
//                                 "paid": isPaid,
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                       child: const Text("Update"),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void handleSavePress() {
//     if (!inventoryPopupShown) {
//       showInventoryPopup();
//     } else {
//       saveBill();
//     }
//   }

//   Widget row(String title, double value, {bool bold = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
//           ),
//           Text(
//             "₹${value.toStringAsFixed(0)}",
//             style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ================= UI =================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(title: Text(widget.billNumber)),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(12),
//               child: Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Column(
//                         children: [
//                           Text(
//                             widget.customerName,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text("Mobile: ${widget.mobile}"),
//                           Text(widget.address),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Bill No: ${widget.billNumber}",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "${widget.billDate.day}/${widget.billDate.month}/${widget.billDate.year}",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),

//                     const Divider(height: 30),

//                     ...widget.items.map(
//                       (item) => Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                         child: Row(
//                           children: [
//                             Expanded(flex: 3, child: Text(item['name'])),
//                             Expanded(
//                               child: Text(
//                                 "${item['qty']}",
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "₹${item['rate']}",
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "₹${item['baseAmount']}",
//                                 textAlign: TextAlign.right,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const Divider(height: 30),

//                     row("Sub Total", widget.subTotal),
//                     row("Extra Charge", widget.charges),
//                     row("Discount", -widget.discount),
//                     row("GST", widget.gstTotal),
//                     row("Cess", widget.cessTotal),

//                     const Divider(),

//                     row("TOTAL", widget.grandTotal, bold: true),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     const Text("Payment status"),
//                     const Spacer(),
//                     Radio(
//                       value: true,
//                       groupValue: isPaid,
//                       onChanged: (_) => setState(() => isPaid = true),
//                     ),
//                     const Text("Paid"),
//                     Radio(
//                       value: false,
//                       groupValue: isPaid,
//                       onChanged: (_) => setState(() => isPaid = false),
//                     ),
//                     const Text("Unpaid"),
//                   ],
//                 ),

//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0C2752),
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   onPressed: handleSavePress,
//                   child: const Text("Save Bill"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:hive/hive.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import '../../../services/api_service.dart';
// import 'create_bill_screen.dart';

// class BillPreviewScreen extends StatefulWidget {
//   final String? billKey;

//   final List<Map<String, dynamic>> items;
//   final String customerName;
//   final String mobile;
//   final String address;
//   final String billNumber;
//   final DateTime billDate;

//   final double subTotal;
//   final double charges;
//   final double discount;
//   final double gstTotal;
//   final double cessTotal;
//   final double grandTotal;

//   const BillPreviewScreen({
//     super.key,
//     required this.billKey,
//     required this.items,
//     required this.customerName,
//     required this.mobile,
//     required this.address,
//     required this.billNumber,
//     required this.billDate,
//     required this.subTotal,
//     required this.charges,
//     required this.discount,
//     required this.gstTotal,
//     required this.cessTotal,
//     required this.grandTotal,
//   });

//   @override
//   State<BillPreviewScreen> createState() => _BillPreviewScreenState();
// }

// class _BillPreviewScreenState extends State<BillPreviewScreen> {
//   bool isPaid = false;
//   bool inventoryPopupShown = false;
//   bool get isLocked => widget.billKey != null && isPaid;

//   /// ================= SAVE BILL =================

//   Future<void> saveBillWithoutNavigation() async {
//     try {
//       final provider = context.read<CustomerProvider>();

//       final settings = Hive.box('settings');
//       final ownerMobile = settings.get('mobile');

//       if (ownerMobile == null) {
//         debugPrint("❌ ownerMobile missing");
//         return;
//       }

//       final billData = {
//         "ownerMobile": ownerMobile,
//         "customerName": widget.customerName,
//         "mobile": widget.mobile,
//         "address": widget.address,
//         "billNumber": widget.billNumber,
//         "date": widget.billDate.toIso8601String(),
//         "items": widget.items,
//         "subTotal": widget.subTotal,
//         "gstTotal": widget.gstTotal,
//         "cessTotal": widget.cessTotal,
//         "charges": widget.charges,
//         "discount": widget.discount,
//         "grandTotal": widget.grandTotal,
//         "paid": isPaid,
//       };

//       debugPrint("📦 Bill Data: $billData");

//       if (widget.billKey != null) {
//         await ApiService.updateBill(widget.billKey!, billData);
//         debugPrint("✏️ Bill Updated");
//       } else {
//         await ApiService.addBill(billData);
//         debugPrint("✅ Bill Saved");
//       }

//       /// ADD TRANSACTION IF UNPAID

//       if (!isPaid) {
//         provider.addTransaction(widget.customerName, {
//           'amount': widget.grandTotal,
//           'note': 'Bill ${widget.billNumber}',
//           'date': DateTime.now(),
//           'type': 'GIVEN',
//         });
//       }
//     } catch (e) {
//       debugPrint("❌ Bill Save Error: $e");
//     }
//   }

//   Future<void> saveBill() async {
//     await saveBillWithoutNavigation();

//     if (!mounted) return;

//     Navigator.pop(context);
//     Navigator.pop(context);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(widget.billKey != null ? "Bill Updated" : "Bill Saved"),
//       ),
//     );
//   }

//   /// ================= INVENTORY POPUP =================

//   void showInventoryPopup() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircleAvatar(
//                 radius: 32,
//                 backgroundColor: Colors.green.shade100,
//                 child: const Icon(
//                   Icons.inventory_2,
//                   color: Colors.green,
//                   size: 30,
//                 ),
//               ),
//               const SizedBox(height: 15),

//               const Text(
//                 "Do you wish to add/update these items in inventory?",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),

//               const SizedBox(height: 20),

//               ...widget.items.map(
//                 (e) => Row(
//                   children: [
//                     Text(e['name']),
//                     const Spacer(),
//                     const Icon(Icons.check_box, color: Colors.green),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         inventoryPopupShown = true;
//                         Navigator.pop(context);
//                       },
//                       child: const Text("Cancel"),
//                     ),
//                   ),

//                   const SizedBox(width: 12),

//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                       ),

//                       onPressed: () async {
//                         inventoryPopupShown = true;

//                         Navigator.pop(context);

//                         await saveBillWithoutNavigation();

//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => CreateBillScreen(
//                               billKey: widget.billKey,
//                               existingBill: {
//                                 "customerName": widget.customerName,
//                                 "mobile": widget.mobile,
//                                 "address": widget.address,
//                                 "billNumber": widget.billNumber,
//                                 "date": widget.billDate.toIso8601String(),
//                                 "items": widget.items,
//                                 "subTotal": widget.subTotal,
//                                 "gstTotal": widget.gstTotal,
//                                 "cessTotal": widget.cessTotal,
//                                 "charges": widget.charges,
//                                 "discount": widget.discount,
//                                 "grandTotal": widget.grandTotal,
//                                 "paid": isPaid,
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                       child: const Text("Update"),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void handleSavePress() {
//     if (!inventoryPopupShown) {
//       showInventoryPopup();
//     } else {
//       saveBill();
//     }
//   }

//   Widget row(String title, double value, {bool bold = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
//           ),
//           Text(
//             "₹${value.toStringAsFixed(0)}",
//             style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ================= UI =================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(title: Text(widget.billNumber)),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(12),
//               child: Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Column(
//                         children: [
//                           Text(
//                             widget.customerName,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text("Mobile: ${widget.mobile}"),
//                           Text(widget.address),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Bill No: ${widget.billNumber}",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "${widget.billDate.day}/${widget.billDate.month}/${widget.billDate.year}",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),

//                     const Divider(height: 30),

//                     ...widget.items.map(
//                       (item) => Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                         child: Row(
//                           children: [
//                             Expanded(flex: 3, child: Text(item['name'])),
//                             Expanded(
//                               child: Text(
//                                 "${item['qty']}",
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "₹${item['rate']}",
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "₹${item['baseAmount']}",
//                                 textAlign: TextAlign.right,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const Divider(height: 30),

//                     row("Sub Total", widget.subTotal),
//                     row("Extra Charge", widget.charges),
//                     row("Discount", -widget.discount),
//                     row("GST", widget.gstTotal),
//                     row("Cess", widget.cessTotal),

//                     const Divider(),

//                     row("TOTAL", widget.grandTotal, bold: true),
//                     if (isPaid)
//                       Container(
//                         margin: const EdgeInsets.only(top: 10),
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             "PAID",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     const Text("Payment status"),
//                     const Spacer(),
//                     Radio(
//                       value: true,
//                       groupValue: isPaid,
//                       onChanged: isLocked
//                           ? null
//                           : (_) => setState(() => isPaid = true),
//                     ),
//                     const Text("Paid"),
//                     Radio(
//                       value: false,
//                       groupValue: isPaid,
//                       onChanged: isLocked
//                           ? null
//                           : (_) => setState(() => isPaid = false),
//                     ),
//                     const Text("Unpaid"),
//                   ],
//                 ),

//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0C2752),
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   onPressed: isLocked ? null : handleSavePress,
//                   child: const Text("Save Bill"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import '../../../services/api_service.dart';
import 'create_bill_screen.dart';

class BillPreviewScreen extends StatefulWidget {
  final String? billKey;
  final bool paid; // ✅ NEW

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
    required this.paid, // ✅ NEW
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
  bool inventoryPopupShown = false;

  bool get isLocked => widget.billKey != null && isPaid;

  @override
  void initState() {
    super.initState();

    /// ✅ backend se paid sync
    isPaid = widget.paid;
  }

  /// ================= SAVE BILL =================

  Future<void> saveBillWithoutNavigation() async {
    try {
      final provider = context.read<CustomerProvider>();

      final settings = Hive.box('settings');
      final ownerMobile = settings.get('mobile');

      if (ownerMobile == null) {
        debugPrint("❌ ownerMobile missing");
        return;
      }

      final billData = {
        "ownerMobile": ownerMobile,
        "customerName": widget.customerName,
        "mobile": widget.mobile,
        "address": widget.address,
        "billNumber": widget.billNumber,
        "date": widget.billDate.toIso8601String(),
        "items": widget.items,
        "subTotal": widget.subTotal,
        "gstTotal": widget.gstTotal,
        "cessTotal": widget.cessTotal,
        "charges": widget.charges,
        "discount": widget.discount,
        "grandTotal": widget.grandTotal,
        "paid": isPaid,
      };

      if (widget.billKey != null) {
        await ApiService.updateBill(widget.billKey!, billData);
      } else {
        await ApiService.addBill(billData);
      }

      /// ✅ ONLY NEW BILL → transaction
      if (widget.billKey == null && !isPaid) {
        provider.addTransaction(widget.customerName, {
          'amount': widget.grandTotal,
          'note': 'Bill ${widget.billNumber}',
          'date': DateTime.now(),
          'type': 'GIVEN',
        });
      }
    } catch (e) {
      debugPrint("❌ Bill Save Error: $e");
    }
  }

  Future<void> saveBill() async {
    await saveBillWithoutNavigation();

    if (!mounted) return;

    Navigator.pop(context);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.billKey != null ? "Bill Updated" : "Bill Saved"),
      ),
    );
  }

  /// ================= INVENTORY POPUP =================

  void showInventoryPopup() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.green.shade100,
                child: const Icon(Icons.inventory_2, color: Colors.green),
              ),

              const SizedBox(height: 15),

              const Text(
                "Do you wish to add/update these items in inventory?",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              ...widget.items.map(
                (e) => Row(
                  children: [
                    Text(e['name']),
                    const Spacer(),
                    const Icon(Icons.check_box, color: Colors.green),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        inventoryPopupShown = true;
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        inventoryPopupShown = true;

                        Navigator.pop(context);

                        await saveBillWithoutNavigation();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateBillScreen(
                              billKey: widget.billKey,
                              existingBill: {
                                "customerName": widget.customerName,
                                "mobile": widget.mobile,
                                "address": widget.address,
                                "billNumber": widget.billNumber,
                                "date": widget.billDate.toIso8601String(),
                                "items": widget.items,
                                "subTotal": widget.subTotal,
                                "gstTotal": widget.gstTotal,
                                "cessTotal": widget.cessTotal,
                                "charges": widget.charges,
                                "discount": widget.discount,
                                "grandTotal": widget.grandTotal,
                                "paid": isPaid,
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text("Update"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void handleSavePress() {
    if (!inventoryPopupShown) {
      showInventoryPopup();
    } else {
      saveBill();
    }
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

  /// ================= UI =================

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
                  children: [
                    Text(
                      widget.customerName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ...widget.items.map(
                      (item) => Row(
                        children: [
                          Expanded(child: Text(item['name'])),
                          Text("${item['qty']}"),
                        ],
                      ),
                    ),

                    const Divider(),

                    row("TOTAL", widget.grandTotal, bold: true),

                    /// ✅ PAID BADGE
                    if (isPaid)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "PAID",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          /// 🔻 BOTTOM
          Container(
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
                      onChanged: isLocked
                          ? null
                          : (_) => setState(() => isPaid = true),
                    ),
                    const Text("Paid"),
                    Radio(
                      value: false,
                      groupValue: isPaid,
                      onChanged: isLocked
                          ? null
                          : (_) => setState(() => isPaid = false),
                    ),
                    const Text("Unpaid"),
                  ],
                ),

                ElevatedButton(
                  onPressed: isLocked ? null : handleSavePress,
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
