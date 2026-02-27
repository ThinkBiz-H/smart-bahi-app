// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'package:frontend/models/customer_model.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ReminderCustomersScreen extends StatefulWidget {
//   const ReminderCustomersScreen({super.key});

//   @override
//   State<ReminderCustomersScreen> createState() =>
//       _ReminderCustomersScreenState();
// }

// class _ReminderCustomersScreenState extends State<ReminderCustomersScreen> {
//   final Map<String, bool> selectedCustomers = {};

//   int? selectedDays;
//   TimeOfDay? selectedTime;

//   void toggleAll(List<Customer> customers, bool value) {
//     setState(() {
//       for (var c in customers) {
//         selectedCustomers[c.name] = value;
//       }
//     });
//   }

//   /// ⏰ TIME PICKER
//   Future<void> pickTime() async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (time != null) {
//       setState(() => selectedTime = time);
//     }
//   }

//   /// 📩 BULK SMS FUNCTION
//   Future<void> sendBulkSMS(List<Customer> customers) async {
//     for (var customer in customers) {
//       final Uri smsUri = Uri(
//         scheme: 'sms',
//         path: customer.mobile,
//         queryParameters: {
//           'body':
//               "Reminder: Hi ${customer.name}, please clear your pending balance. - SmartBahi",
//         },
//       );

//       await launchUrl(smsUri);
//       await Future.delayed(const Duration(seconds: 2));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final customers = context.watch<CustomerProvider>().customers;

//     bool isReady =
//         selectedCustomers.values.contains(true) &&
//         selectedDays != null &&
//         selectedTime != null;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Set Reminder"), centerTitle: true),
//       body: Column(
//         children: [
//           /// SELECT ALL
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

//           /// CUSTOMER LIST
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

//           /// DAYS SELECTION
//           const Divider(),
//           const Padding(
//             padding: EdgeInsets.only(top: 10),
//             child: Text(
//               "Start reminder after",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),

//           RadioListTile(
//             title: const Text("3 Days"),
//             value: 3,
//             groupValue: selectedDays,
//             onChanged: (v) => setState(() => selectedDays = v as int),
//           ),
//           RadioListTile(
//             title: const Text("7 Days"),
//             value: 7,
//             groupValue: selectedDays,
//             onChanged: (v) => setState(() => selectedDays = v as int),
//           ),
//           RadioListTile(
//             title: const Text("10 Days"),
//             value: 10,
//             groupValue: selectedDays,
//             onChanged: (v) => setState(() => selectedDays = v as int),
//           ),

//           /// TIME PICKER
//           ListTile(
//             leading: const Icon(Icons.access_time),
//             title: Text(
//               selectedTime == null
//                   ? "Select Reminder Time"
//                   : selectedTime!.format(context),
//             ),
//             trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//             onTap: pickTime,
//           ),

//           /// SEND BUTTON
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: SizedBox(
//               width: double.infinity,
//               height: 58,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1E8E3E),
//                   elevation: 6,
//                   shadowColor: Colors.black26,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 onPressed: isReady
//                     ? () async {
//                         final provider = context.read<CustomerProvider>();

//                         final selected = selectedCustomers.entries
//                             .where((e) => e.value)
//                             .map((e) => e.key)
//                             .toList();

//                         final selectedCustomersList = selected
//                             .map((name) => provider.getCustomer(name))
//                             .toList();

//                         await sendBulkSMS(selectedCustomersList);

//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               "Bulk reminder started for ${selected.length} customers",
//                             ),
//                           ),
//                         );
//                       }
//                     : null,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.send_rounded, color: Colors.white),
//                     SizedBox(width: 8),
//                     Text(
//                       "SEND BULK SMS",
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ///// main code bhai iswko nhi sedenge
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'package:frontend/models/customer_model.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ReminderCustomersScreen extends StatefulWidget {
//   const ReminderCustomersScreen({super.key});
//   bool sendToAllCustomers = false;
//   @override
//   State<ReminderCustomersScreen> createState() =>
//       _ReminderCustomersScreenState();
// }

// class _ReminderCustomersScreenState extends State<ReminderCustomersScreen>
//     with SingleTickerProviderStateMixin {
//   final Map<String, bool> selectedCustomers = {};
//   int? selectedDays;
//   TimeOfDay? selectedTime;

//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
//           CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//         );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   void toggleAll(List<Customer> customers, bool value) {
//     setState(() {
//       for (var c in customers) {
//         selectedCustomers[c.name] = value;
//       }
//     });
//   }

//   Future<void> pickTime() async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF1E8E3E),
//               onPrimary: Colors.white,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (time != null) {
//       setState(() => selectedTime = time);
//     }
//   }

//   Future<void> sendBulkSMS(List<Customer> customers) async {
//     for (var customer in customers) {
//       final Uri smsUri = Uri(
//         scheme: 'sms',
//         path: customer.mobile,
//         queryParameters: {
//           'body':
//               "Reminder: Hi ${customer.name}, please clear your pending balance. - SmartBahi",
//         },
//       );
//       await launchUrl(smsUri);
//       await Future.delayed(const Duration(milliseconds: 500));
//     }
//   }

//   List<Customer> _getFilteredCustomers(List<Customer> customers) {
//     if (_searchQuery.isEmpty) return customers;
//     return customers.where((customer) {
//       return customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//           customer.mobile.contains(_searchQuery);
//     }).toList();
//   }

//   int getSelectedCount(List<Customer> customers) {
//     return selectedCustomers.entries.where((e) => e.value).length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final customers = context.watch<CustomerProvider>().customers;
//     final filteredCustomers = _getFilteredCustomers(customers);
//     final selectedCount = sendToAllCustomers
//         ? customers.length
//         : getSelectedCount(customers);

//     bool isReady =
//         (sendToAllCustomers || selectedCount > 0) &&
//         selectedDays != null &&
//         selectedTime != null;
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         title: const Text(
//           "Set Reminder",
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 22,
//             letterSpacing: 0.5,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.info_outline_rounded),
//             onPressed: () {
//               _showInfoDialog(context);
//             },
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(color: Colors.grey[200], height: 1),
//         ),
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: Column(
//             children: [
//               /// Search Bar
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.white,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Search customers...',
//                       hintStyle: TextStyle(color: Colors.grey[500]),
//                       prefixIcon: Icon(
//                         Icons.search_rounded,
//                         color: Colors.grey[600],
//                       ),
//                       suffixIcon: _searchQuery.isNotEmpty
//                           ? IconButton(
//                               icon: Icon(Icons.clear, color: Colors.grey[600]),
//                               onPressed: () {
//                                 _searchController.clear();
//                                 setState(() {
//                                   _searchQuery = '';
//                                 });
//                               },
//                             )
//                           : null,
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                   ),
//                 ),
//               ),

//               /// Select All Card
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       spreadRadius: 1,
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: CheckboxListTile(
//                   title: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF1E8E3E).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Icon(
//                           Icons.group_rounded,
//                           color: Color(0xFF1E8E3E),
//                           size: 20,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Select All Customers",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               "${filteredCustomers.length} customers available",
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   value:
//                       filteredCustomers.isNotEmpty &&
//                       filteredCustomers.every(
//                         (c) => selectedCustomers[c.name] == true,
//                       ),
//                   onChanged: (val) {
//                     if (val != null) {
//                       setState(() {
//                         for (var c in filteredCustomers) {
//                           selectedCustomers[c.name] = val;
//                         }
//                       });
//                     }
//                   },
//                   activeColor: const Color(0xFF1E8E3E),
//                   checkColor: Colors.white,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                 ),
//               ),

//               /// Customer List Header
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Select Customers",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                         color: Colors.grey[800],
//                       ),
//                     ),
//                     if (selectedCount > 0)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF1E8E3E).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           "$selectedCount selected",
//                           style: const TextStyle(
//                             color: Color(0xFF1E8E3E),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),

//               /// Customer List
//               Expanded(
//                 child: filteredCustomers.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.person_off_rounded,
//                               size: 64,
//                               color: Colors.grey[400],
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               _searchQuery.isEmpty
//                                   ? "No customers found"
//                                   : "No matching customers",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             if (_searchQuery.isNotEmpty)
//                               TextButton(
//                                 onPressed: () {
//                                   _searchController.clear();
//                                   setState(() {
//                                     _searchQuery = '';
//                                   });
//                                 },
//                                 child: const Text("Clear search"),
//                               ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: filteredCustomers.length,
//                         itemBuilder: (context, index) {
//                           final customer = filteredCustomers[index];
//                           final isSelected =
//                               selectedCustomers[customer.name] ?? false;

//                           return AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             margin: const EdgeInsets.only(bottom: 8),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: isSelected
//                                     ? const Color(0xFF1E8E3E)
//                                     : Colors.transparent,
//                                 width: 1.5,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.05),
//                                   spreadRadius: 1,
//                                   blurRadius: 5,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: CheckboxListTile(
//                               value: isSelected,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedCustomers[customer.name] =
//                                       value ?? false;
//                                 });
//                                 if (value == true) {
//                                   HapticFeedback.lightImpact();
//                                 }
//                               },
//                               title: Text(
//                                 customer.name,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 customer.mobile,
//                                 style: TextStyle(
//                                   color: Colors.grey[600],
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               secondary: Container(
//                                 width: 48,
//                                 height: 48,
//                                 decoration: BoxDecoration(
//                                   color: const Color(
//                                     0xFF1E8E3E,
//                                   ).withOpacity(0.1),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     (customer.name.isNotEmpty
//                                         ? customer.name[0].toUpperCase()
//                                         : "?"),
//                                     style: const TextStyle(
//                                       color: Color(0xFF1E8E3E),
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               activeColor: const Color(0xFF1E8E3E),
//                               checkColor: Colors.white,
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),

//               /// Settings Section
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(24),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       spreadRadius: -5,
//                       blurRadius: 10,
//                       offset: const Offset(0, -5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 16),

//                     /// Days Selection
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.calendar_today_rounded,
//                             color: Color(0xFF1E8E3E),
//                             size: 20,
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             "Send reminder after",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         children: [3, 7, 10, 15, 30].map((days) {
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 8),
//                             child: FilterChip(
//                               label: Text("$days days"),
//                               selected: selectedDays == days,
//                               onSelected: (selected) {
//                                 setState(() {
//                                   selectedDays = selected ? days : null;
//                                 });
//                               },
//                               selectedColor: const Color(
//                                 0xFF1E8E3E,
//                               ).withOpacity(0.1),
//                               checkmarkColor: const Color(0xFF1E8E3E),
//                               labelStyle: TextStyle(
//                                 color: selectedDays == days
//                                     ? const Color(0xFF1E8E3E)
//                                     : Colors.black87,
//                                 fontWeight: selectedDays == days
//                                     ? FontWeight.w600
//                                     : FontWeight.normal,
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 12,
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     /// Time Picker
//                     ListTile(
//                       leading: Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF1E8E3E).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Icon(
//                           Icons.access_time_rounded,
//                           color: Color(0xFF1E8E3E),
//                           size: 20,
//                         ),
//                       ),
//                       title: Text(
//                         selectedTime == null
//                             ? "Select reminder time"
//                             : "Reminder time",
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                       subtitle: selectedTime != null
//                           ? Text(
//                               selectedTime!.format(context),
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 14,
//                               ),
//                             )
//                           : null,
//                       trailing: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: selectedTime == null
//                               ? Colors.grey[100]
//                               : const Color(0xFF1E8E3E).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           selectedTime == null ? "Set" : "Change",
//                           style: TextStyle(
//                             color: selectedTime == null
//                                 ? Colors.grey[600]
//                                 : const Color(0xFF1E8E3E),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       onTap: pickTime,
//                     ),

//                     const SizedBox(height: 16),

//                     /// Send Button
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         width: double.infinity,
//                         height: 58,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: isReady
//                               ? [
//                                   BoxShadow(
//                                     color: const Color(
//                                       0xFF1E8E3E,
//                                     ).withOpacity(0.3),
//                                     blurRadius: 15,
//                                     offset: const Offset(0, 5),
//                                   ),
//                                 ]
//                               : [],
//                         ),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: isReady
//                                 ? const Color(0xFF1E8E3E)
//                                 : Colors.grey[300],
//                             foregroundColor: isReady
//                                 ? Colors.white
//                                 : Colors.grey[600],
//                             elevation: isReady ? 6 : 0,
//                             shadowColor: const Color(
//                               0xFF1E8E3E,
//                             ).withOpacity(0.3),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           onPressed: isReady
//                               ? () async {
//                                   final provider = context
//                                       .read<CustomerProvider>();
//                                   final selected = selectedCustomers.entries
//                                       .where((e) => e.value)
//                                       .map((e) => e.key)
//                                       .toList();

//                                   final selectedCustomersList = selected
//                                       .map((name) => provider.getCustomer(name))
//                                       .toList();

//                                   // Show loading dialog
//                                   showDialog(
//                                     context: context,
//                                     barrierDismissible: false,
//                                     builder: (context) => const Center(
//                                       child: CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                               Color(0xFF1E8E3E),
//                                             ),
//                                       ),
//                                     ),
//                                   );

//                                   await sendBulkSMS(selectedCustomersList);

//                                   if (mounted) {
//                                     Navigator.pop(context); // Remove loading

//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Row(
//                                           children: [
//                                             const Icon(
//                                               Icons.check_circle_rounded,
//                                               color: Colors.white,
//                                             ),
//                                             const SizedBox(width: 12),
//                                             Expanded(
//                                               child: Text(
//                                                 "Reminders sent to ${selected.length} customer${selected.length > 1 ? 's' : ''}",
//                                                 style: const TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         backgroundColor: const Color(
//                                           0xFF1E8E3E,
//                                         ),
//                                         behavior: SnackBarBehavior.floating,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                         ),
//                                         margin: const EdgeInsets.all(16),
//                                       ),
//                                     );
//                                   }
//                                 }
//                               : null,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 isReady
//                                     ? Icons.send_rounded
//                                     : Icons.lock_outline_rounded,
//                                 size: 22,
//                               ),
//                               const SizedBox(width: 12),
//                               Text(
//                                 isReady
//                                     ? "SEND REMINDERS"
//                                     : "COMPLETE ALL FIELDS",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700,
//                                   letterSpacing: 0.8,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showInfoDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         title: const Row(
//           children: [
//             Icon(Icons.info_rounded, color: Color(0xFF1E8E3E)),
//             SizedBox(width: 8),
//             Text("About Reminders"),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildInfoRow(
//               Icons.people_rounded,
//               "Select customers for reminders",
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               Icons.calendar_today_rounded,
//               "Choose reminder frequency",
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               Icons.access_time_rounded,
//               "Set preferred reminder time",
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               Icons.sms_rounded,
//               "Bulk SMS will be sent automatically",
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(
//               foregroundColor: const Color(0xFF1E8E3E),
//             ),
//             child: const Text("GOT IT"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: Colors.grey[600]),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(color: Colors.grey[700], fontSize: 14),
//           ),
//         ),
//       ],
//     );
//   }
// }

///try cod4 //

// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'package:frontend/models/customer_model.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ReminderCustomersScreen extends StatefulWidget {
//   const ReminderCustomersScreen({super.key});

//   @override
//   State<ReminderCustomersScreen> createState() =>
//       _ReminderCustomersScreenState();
// }

// class _ReminderCustomersScreenState extends State<ReminderCustomersScreen>
//     with SingleTickerProviderStateMixin {
//   final Map<String, bool> selectedCustomers = {};

//   bool sendToAllCustomers = false; // ⭐ FIXED

//   int? selectedDays;
//   TimeOfDay? selectedTime;

//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
//           CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//         );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> pickTime() async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (time != null) {
//       setState(() => selectedTime = time);
//     }
//   }

//   Future<void> sendBulkSMS(List<Customer> customers) async {
//     for (var customer in customers) {
//       final Uri smsUri = Uri(
//         scheme: 'sms',
//         path: customer.mobile,
//         queryParameters: {
//           'body':
//               "Reminder: Hi ${customer.name}, please clear your pending balance. - SmartBahi",
//         },
//       );

//       await launchUrl(smsUri);
//       await Future.delayed(const Duration(milliseconds: 500));
//     }
//   }

//   int getSelectedCount() {
//     return selectedCustomers.entries.where((e) => e.value).length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final customers = context.watch<CustomerProvider>().customers;

//     final selectedCount = selectedCustomers.values
//         .where((v) => v == true)
//         .length;

//     bool isReady =
//         (sendToAllCustomers || selectedCount > 0) &&
//         selectedDays != null &&
//         selectedTime != null;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(title: const Text("Set Reminder"), centerTitle: true),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: Column(
//             children: [
//               // ⭐ MODE SELECTOR
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ChoiceChip(
//                         label: Text("All Customers (${customers.length})"),
//                         selected: sendToAllCustomers,
//                         onSelected: (_) {
//                           setState(() {
//                             sendToAllCustomers = true;

//                             // ⭐ AUTO SELECT ALL CUSTOMERS
//                             for (var c in customers) {
//                               selectedCustomers[c.name] = true;
//                             }
//                           });
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: ChoiceChip(
//                         label: Text("Selected Customers ($selectedCount)"),
//                         selected: !sendToAllCustomers,
//                         onSelected: (_) {
//                           setState(() {
//                             sendToAllCustomers = false;

//                             // ⭐ CLEAR ALL SELECTIONS
//                             selectedCustomers.clear();
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // ⭐ CUSTOMER LIST (only if Selected Mode)
//               if (!sendToAllCustomers)
//                 // ⭐ CUSTOMER LIST (Always visible)
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: customers.length,
//                     itemBuilder: (context, index) {
//                       final customer = customers[index];

//                       final isSelected =
//                           selectedCustomers[customer.name] ?? false;

//                       return CheckboxListTile(
//                         value: sendToAllCustomers ? true : isSelected,

//                         // ⭐ MOST IMPORTANT PART
//                         onChanged: sendToAllCustomers
//                             ? null // All mode = disabled checkbox
//                             : (value) {
//                                 setState(() {
//                                   selectedCustomers[customer.name] =
//                                       value ?? false;
//                                 });

//                                 if (value == true) {
//                                   HapticFeedback.lightImpact();
//                                 }
//                               },

//                         title: Text(customer.name),
//                         subtitle: Text(customer.mobile),
//                       );
//                     },
//                   ),
//                 ),

//               const SizedBox(height: 10),

//               // DAYS
//               Wrap(
//                 spacing: 10,
//                 children: [3, 7, 10].map((days) {
//                   return ChoiceChip(
//                     label: Text("$days days"),
//                     selected: selectedDays == days,
//                     onSelected: (_) {
//                       setState(() {
//                         selectedDays = days;
//                       });
//                     },
//                   );
//                 }).toList(),
//               ),

//               const SizedBox(height: 10),

//               // TIME
//               ListTile(
//                 title: Text(
//                   selectedTime == null
//                       ? "Select Time"
//                       : selectedTime!.format(context),
//                 ),
//                 onTap: pickTime,
//               ),

//               const SizedBox(height: 10),

//               // SEND BUTTON
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 55,
//                   child: ElevatedButton(
//                     onPressed: isReady
//                         ? () async {
//                             final provider = context.read<CustomerProvider>();

//                             List<Customer> targetCustomers;

//                             if (sendToAllCustomers) {
//                               targetCustomers = customers;
//                             } else {
//                               final selected = selectedCustomers.entries
//                                   .where((e) => e.value)
//                                   .map((e) => e.key)
//                                   .toList();

//                               targetCustomers = selected
//                                   .map((name) => provider.getCustomer(name))
//                                   .toList();
//                             }

//                             await sendBulkSMS(targetCustomers);

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   "Reminders sent to ${targetCustomers.length} customers",
//                                 ),
//                               ),
//                             );
//                           }
//                         : null,
//                     child: Text(
//                       isReady ? "SEND REMINDERS" : "COMPLETE ALL FIELDS",
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// // }
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'package:frontend/models/customer_model.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ReminderCustomersScreen extends StatefulWidget {
//   const ReminderCustomersScreen({super.key});

//   @override
//   State<ReminderCustomersScreen> createState() =>
//       _ReminderCustomersScreenState();
// }

// class _ReminderCustomersScreenState extends State<ReminderCustomersScreen>
//     with SingleTickerProviderStateMixin {
//   final Map<String, bool> selectedCustomers = {};

//   bool sendToAllCustomers = true;
//   int? selectedDays;
//   TimeOfDay? selectedTime;

//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );

//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
//           CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//         );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> pickTime() async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (time != null) setState(() => selectedTime = time);
//   }

//   Future<void> sendBulkSMS(List<Customer> customers) async {
//     for (var customer in customers) {
//       final Uri smsUri = Uri(
//         scheme: 'sms',
//         path: customer.mobile,
//         queryParameters: {
//           'body':
//               "Reminder: Hi ${customer.name}, please clear your pending balance. - SmartBahi",
//         },
//       );
//       await launchUrl(smsUri);
//       await Future.delayed(const Duration(milliseconds: 400));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final customers = context.watch<CustomerProvider>().customers;

//     // ⭐ COUNT
//     final selectedCount = selectedCustomers.values
//         .where((v) => v == true)
//         .length;

//     // ⭐ FILTERED LIST (MAIN MAGIC)
//     List<Customer> visibleCustomers;
//     if (sendToAllCustomers) {
//       visibleCustomers = customers;
//     } else {
//       visibleCustomers = customers
//           .where((c) => selectedCustomers[c.name] == true)
//           .toList();
//     }

//     bool isReady =
//         (sendToAllCustomers || selectedCount > 0) &&
//         selectedDays != null &&
//         selectedTime != null;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(title: const Text("Set Reminder"), centerTitle: true),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: Column(
//             children: [
//               /// MODE SELECTOR
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ChoiceChip(
//                         label: Text("All Customers (${customers.length})"),
//                         selected: sendToAllCustomers,
//                         onSelected: (_) {
//                           setState(() => sendToAllCustomers = true);
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: ChoiceChip(
//                         label: Text("Selected Customers ($selectedCount)"),
//                         selected: !sendToAllCustomers,
//                         onSelected: (_) {
//                           setState(() => sendToAllCustomers = false);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               /// CUSTOMER LIST (FILTERED)
//               Expanded(
//                 child: visibleCustomers.isEmpty
//                     ? const Center(child: Text("No selected customers"))
//                     : ListView.builder(
//                         itemCount: visibleCustomers.length,
//                         itemBuilder: (context, index) {
//                           final customer = visibleCustomers[index];
//                           final isSelected =
//                               selectedCustomers[customer.name] ?? false;

//                           return CheckboxListTile(
//                             value: isSelected,
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedCustomers[customer.name] =
//                                     value ?? false;
//                               });
//                               if (value == true) {
//                                 HapticFeedback.lightImpact();
//                               }
//                             },
//                             title: Text(customer.name),
//                             subtitle: Text(customer.mobile),
//                           );
//                         },
//                       ),
//               ),

//               const SizedBox(height: 10),

//               /// DAYS
//               Wrap(
//                 spacing: 10,
//                 children: [3, 7, 10].map((days) {
//                   return ChoiceChip(
//                     label: Text("$days days"),
//                     selected: selectedDays == days,
//                     onSelected: (_) => setState(() => selectedDays = days),
//                   );
//                 }).toList(),
//               ),

//               const SizedBox(height: 10),

//               /// TIME
//               ListTile(
//                 title: Text(
//                   selectedTime == null
//                       ? "Select Time"
//                       : selectedTime!.format(context),
//                 ),
//                 onTap: pickTime,
//               ),

//               const SizedBox(height: 10),

//               /// SEND BUTTON
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 55,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isReady
//                           ? const Color(0xFF1E8E3E)
//                           : Colors.grey.shade300,
//                       foregroundColor: isReady
//                           ? Colors.white
//                           : Colors.grey.shade600,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     onPressed: isReady
//                         ? () async {
//                             List<Customer> targetCustomers;

//                             if (sendToAllCustomers) {
//                               targetCustomers = customers;
//                             } else {
//                               targetCustomers = customers
//                                   .where(
//                                     (c) => selectedCustomers[c.name] == true,
//                                   )
//                                   .toList();
//                             }

//                             await sendBulkSMS(targetCustomers);

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   "Reminders sent to ${targetCustomers.length} customers",
//                                 ),
//                               ),
//                             );
//                           }
//                         : null,
//                     child: Text(
//                       isReady ? "SEND REMINDERS" : "COMPLETE ALL FIELDS",
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/services.dart';
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

class _ReminderCustomersScreenState extends State<ReminderCustomersScreen>
    with SingleTickerProviderStateMixin {
  final Map<String, bool> selectedCustomers = {};

  bool sendToAllCustomers = true;
  int? selectedDays;
  TimeOfDay? selectedTime;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E8E3E),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) setState(() => selectedTime = time);
  }

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
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  List<Customer> _getFilteredCustomers(List<Customer> customers) {
    if (_searchQuery.isEmpty) return customers;
    return customers.where((customer) {
      return customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer.mobile.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final customers = context.watch<CustomerProvider>().customers;
    final filteredCustomers = _getFilteredCustomers(customers);

    // ⭐ COUNT
    final selectedCount = selectedCustomers.values
        .where((v) => v == true)
        .length;

    // ⭐ FILTERED LIST (MAIN MAGIC)
    List<Customer> visibleCustomers;
    if (sendToAllCustomers) {
      visibleCustomers = filteredCustomers;
    } else {
      visibleCustomers = filteredCustomers
          .where((c) => selectedCustomers[c.name] == true)
          .toList();
    }

    bool isReady =
        (sendToAllCustomers || selectedCount > 0) &&
        selectedDays != null &&
        selectedTime != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          "Set Reminder",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              /// Search Bar
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search customers...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.grey[600],
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[600]),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),

              /// MODE SELECTOR - Modern Design
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildModeChip(
                          label: "All Customers",
                          count: customers.length,
                          isSelected: sendToAllCustomers,
                          onTap: () {
                            setState(() => sendToAllCustomers = true);
                            HapticFeedback.lightImpact();
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _buildModeChip(
                          label: "Selected",
                          count: selectedCount,
                          isSelected: !sendToAllCustomers,
                          onTap: () {
                            setState(() => sendToAllCustomers = false);
                            HapticFeedback.lightImpact();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Customer List Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sendToAllCustomers
                          ? "All Customers"
                          : "Selected Customers",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E8E3E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${visibleCustomers.length} ${visibleCustomers.length == 1 ? 'customer' : 'customers'}",
                        style: const TextStyle(
                          color: Color(0xFF1E8E3E),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              /// CUSTOMER LIST (FILTERED)
              Expanded(
                child: visibleCustomers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              sendToAllCustomers
                                  ? Icons.people_outline_rounded
                                  : Icons.check_circle_outline_rounded,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              sendToAllCustomers
                                  ? _searchQuery.isEmpty
                                        ? "No customers found"
                                        : "No matching customers"
                                  : "No customers selected",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                child: const Text("Clear search"),
                              ),
                            if (!sendToAllCustomers && selectedCount == 0)
                              TextButton(
                                onPressed: () {
                                  setState(() => sendToAllCustomers = true);
                                },
                                child: const Text("Switch to all customers"),
                              ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: visibleCustomers.length,
                        itemBuilder: (context, index) {
                          final customer = visibleCustomers[index];
                          final isSelected =
                              selectedCustomers[customer.name] ?? false;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1E8E3E)
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.05),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CheckboxListTile(
                              value: isSelected,
                              onChanged: sendToAllCustomers
                                  ? (value) {
                                      setState(() {
                                        selectedCustomers[customer.name] =
                                            value ?? false;
                                      });
                                      if (value == true) {
                                        HapticFeedback.lightImpact();
                                      }
                                    }
                                  : null, // Disable when in "Selected" mode
                              title: Text(
                                customer.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                customer.mobile,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              secondary: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF1E8E3E,
                                  ).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    customer.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF1E8E3E),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              activeColor: const Color(0xFF1E8E3E),
                              checkColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                          );
                        },
                      ),
              ),

              /// Settings Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: -5,
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    /// Days Selection
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E8E3E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_today_rounded,
                              color: Color(0xFF1E8E3E),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Send reminder after",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Day Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [3, 7, 10, 15, 30].map((days) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text("$days days"),
                              selected: selectedDays == days,
                              onSelected: (_) {
                                setState(() => selectedDays = days);
                                HapticFeedback.lightImpact();
                              },
                              selectedColor: const Color(
                                0xFF1E8E3E,
                              ).withOpacity(0.1),
                              checkmarkColor: const Color(0xFF1E8E3E),
                              labelStyle: TextStyle(
                                color: selectedDays == days
                                    ? const Color(0xFF1E8E3E)
                                    : Colors.black87,
                                fontWeight: selectedDays == days
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Time Picker
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E8E3E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.access_time_rounded,
                          color: Color(0xFF1E8E3E),
                          size: 20,
                        ),
                      ),
                      title: const Text(
                        "Reminder time",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: selectedTime != null
                          ? Text(
                              selectedTime!.format(context),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            )
                          : const Text(
                              "Select when to send",
                              style: TextStyle(color: Colors.grey),
                            ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: selectedTime == null
                              ? Colors.grey[100]
                              : const Color(0xFF1E8E3E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          selectedTime == null ? "Set" : "Change",
                          style: TextStyle(
                            color: selectedTime == null
                                ? Colors.grey[600]
                                : const Color(0xFF1E8E3E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: pickTime,
                    ),

                    const SizedBox(height: 16),

                    /// SEND BUTTON
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isReady
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF1E8E3E,
                                    ).withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : [],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isReady
                                ? const Color(0xFF1E8E3E)
                                : Colors.grey[300],
                            foregroundColor: isReady
                                ? Colors.white
                                : Colors.grey[600],
                            elevation: isReady ? 6 : 0,
                            shadowColor: const Color(
                              0xFF1E8E3E,
                            ).withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: isReady
                              ? () async {
                                  List<Customer> targetCustomers;

                                  if (sendToAllCustomers) {
                                    targetCustomers = customers;
                                  } else {
                                    targetCustomers = customers
                                        .where(
                                          (c) =>
                                              selectedCustomers[c.name] == true,
                                        )
                                        .toList();
                                  }

                                  // Show loading
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xFF1E8E3E),
                                            ),
                                      ),
                                    ),
                                  );

                                  await sendBulkSMS(targetCustomers);

                                  if (mounted) {
                                    Navigator.pop(context); // Remove loading

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                "Reminders sent to ${targetCustomers.length} customer${targetCustomers.length > 1 ? 's' : ''}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: const Color(
                                          0xFF1E8E3E,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        margin: const EdgeInsets.all(16),
                                      ),
                                    );
                                  }
                                }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isReady
                                    ? Icons.send_rounded
                                    : Icons.lock_outline_rounded,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isReady
                                    ? "SEND REMINDERS"
                                    : "COMPLETE ALL FIELDS",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeChip({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: " ($count)",
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF1E8E3E)
                        : Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.info_rounded, color: Color(0xFF1E8E3E)),
            SizedBox(width: 8),
            Text("About Reminders"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              Icons.people_rounded,
              "Send to all or selected customers",
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today_rounded,
              "Choose reminder frequency (3-30 days)",
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.access_time_rounded,
              "Set preferred reminder time",
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.sms_rounded,
              "Bulk SMS will be sent automatically",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1E8E3E),
            ),
            child: const Text("GOT IT"),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ),
      ],
    );
  }
}
