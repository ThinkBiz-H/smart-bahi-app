// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import 'customer_sms_settings_screen.dart';

// class CustomerProfileScreen extends StatelessWidget {
//   final String customerName;

//   const CustomerProfileScreen({super.key, required this.customerName});

//   Widget cardTile(
//     IconData icon,
//     String title, {
//     VoidCallback? onTap,
//     Color? color,
//     String? subtitle,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       decoration: BoxDecoration(
//         color: const Color(0xfff1f3f4),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: ListTile(
//         leading: Icon(icon, color: color ?? Colors.green),
//         title: Text(title, style: TextStyle(color: color ?? Colors.black)),
//         subtitle: subtitle != null ? Text(subtitle) : null,
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final customer = provider.getCustomer(customerName);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Profile"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: ListView(
//         children: [
//           const SizedBox(height: 20),

//           /// PROFILE IMAGE
//           Center(
//             child: Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 45,
//                   backgroundColor: Colors.grey.shade300,
//                   child: Text(
//                     customer.name[0].toUpperCase(),
//                     style: const TextStyle(fontSize: 30),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundColor: Colors.green,
//                     child: const Icon(
//                       Icons.camera_alt,
//                       size: 16,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           /// NAME CARD
//           cardTile(Icons.person, customer.name),

//           const Padding(
//             padding: EdgeInsets.fromLTRB(16, 20, 0, 8),
//             child: Text(
//               "Contact Information",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),

//           /// PHONE
//           cardTile(Icons.phone_android, customer.mobile),

//           /// ADDRESS
//           cardTile(Icons.location_on, "Add Address"),

//           const Padding(
//             padding: EdgeInsets.fromLTRB(16, 20, 0, 8),
//             child: Text(
//               "Communications",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),

//           /// ⭐ SMS SETTINGS (IMPORTANT)
//           cardTile(
//             Icons.sms,
//             "SMS Settings",
//             subtitle: "Transactions SMS, Language",
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       CustomerSmsSettingsScreen(customerName: customer.name),
//                 ),
//               );
//             },
//           ),

//           const SizedBox(height: 10),

//           /// DELETE BUTTON
//           cardTile(Icons.delete, "Delete", color: Colors.red),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import 'add_customer_screen.dart';
// import 'customer_sms_settings_screen.dart';

// class CustomerProfileScreen extends StatelessWidget {
//   final String customerName;

//   const CustomerProfileScreen({super.key, required this.customerName});

//   Widget tile(
//     IconData icon,
//     String title, {
//     VoidCallback? onTap,
//     Color? color,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: color ?? Colors.black87),
//       title: Text(
//         title,
//         style: TextStyle(fontSize: 16, color: color ?? Colors.black87),
//       ),
//       onTap: onTap,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final customer = provider.getCustomer(customerName);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       AddCustomerScreen(customer: customer, isEdit: true),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),

//       body: ListView(
//         children: [
//           const SizedBox(height: 20),

//           /// PROFILE AVATAR
//           const CircleAvatar(
//             radius: 45,
//             backgroundColor: Color(0xffE8DEF8),
//             child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
//           ),

//           const SizedBox(height: 25),

//           /// NAME
//           tile(Icons.person, customer.name),
//           tile(Icons.phone, customer.mobile),
//           tile(Icons.location_on, customer.address),

//           const Divider(height: 30),

//           /// SMS SETTINGS
//           tile(
//             Icons.sms,
//             "SMS Settings",
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       CustomerSmsSettingsScreen(customerName: customer.name),
//                 ),
//               );
//             },
//           ),

//           const Divider(height: 30),

//           /// BLOCK
//           tile(Icons.block, "Block", color: Colors.red),

//           /// DELETE
//           tile(Icons.delete, "Delete Customer", color: Colors.red),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import 'add_customer_screen.dart';
import 'customer_sms_settings_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  final String customerName;

  const CustomerProfileScreen({super.key, required this.customerName});

  Widget tile(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: color ?? Colors.black87),
      ),
      onTap: onTap,
    );
  }

  void _confirmDelete(BuildContext context, CustomerProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Customer"),
        content: const Text("Are you sure you want to delete this customer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              provider.deleteCustomer(customerName);

              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to list
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final customer = provider.getCustomer(customerName);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      AddCustomerScreen(customer: customer, isEdit: true),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xffE8DEF8),
            child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
          ),

          const SizedBox(height: 25),

          tile(Icons.person, customer.name),
          tile(Icons.phone, customer.mobile),
          tile(Icons.location_on, customer.address),

          const Divider(height: 30),

          tile(
            Icons.sms,
            "SMS Settings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CustomerSmsSettingsScreen(customerName: customer.name),
                ),
              );
            },
          ),

          const Divider(height: 30),

          tile(Icons.block, "Block", color: Colors.red),

          tile(
            Icons.delete,
            "Delete Customer",
            color: Colors.red,
            onTap: () => _confirmDelete(context, provider),
          ),
        ],
      ),
    );
  }
}
