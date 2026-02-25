// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/material.dart';

// class Customer {
//   String name;
//   String mobile;
//   String address;
//   String type; // CUSTOMER / SUPPLIER

//   bool smsEnabled; // ⭐⭐ NEW FIELD ⭐⭐

//   List<Map<String, dynamic>> transactions = [];

//   Customer({
//     required this.name,
//     required this.mobile,
//     required this.address,
//     required this.type,
//     this.smsEnabled = false, // ⭐ default OFF
//   });

//   double get balance {
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
// }

// class CustomerProvider extends ChangeNotifier {
//   final List<Customer> _people = [];

//   /// FILTERED LISTS
//   List<Customer> get customers =>
//       _people.where((p) => p.type == "CUSTOMER").toList();

//   List<Customer> get suppliers =>
//       _people.where((p) => p.type == "SUPPLIER").toList();

//   /// ADD PERSON
//   void addPerson(String name, String mobile, String address, String type) {
//     if (_people.any((p) => p.name == name)) return;

//     _people.add(
//       Customer(name: name, mobile: mobile, address: address, type: type),
//     );

//     notifyListeners();
//   }

//   void addCustomer(String name, String mobile, String address) {
//     addPerson(name, mobile, address, "CUSTOMER");
//   }

//   void updateCustomer(
//     String oldName,
//     String name,
//     String mobile,
//     String address,
//   ) {
//     final index = _people.indexWhere((p) => p.name == oldName);
//     if (index == -1) return;

//     _people[index].name = name;
//     _people[index].mobile = mobile;
//     _people[index].address = address;

//     notifyListeners();
//   }

//   void deleteCustomer(String name) {
//     _people.removeWhere((p) => p.name == name);
//     notifyListeners();
//   }

//   /// ⭐ TOGGLE SMS
//   void toggleCustomerSMS(Customer customer, bool value) {
//     customer.smsEnabled = value;
//     notifyListeners();
//   }

//   // ================= SMS FUNCTION =================

//   Future<void> sendSmsIfEnabled(
//     Customer customer,
//     Map<String, dynamic> tx,
//   ) async {
//     if (!customer.smsEnabled) return;

//     final amount = tx["amount"];
//     final isGiven = tx["type"] == "GIVEN";

//     String message;

//     if (isGiven) {
//       message =
//           "Hi ${customer.name}, you received ₹$amount from me. - SmartBahi";
//     } else {
//       message =
//           "Hi ${customer.name}, you paid ₹$amount. Thank you! - SmartBahi";
//     }

//     final Uri smsUri = Uri(
//       scheme: 'sms',
//       path: customer.mobile,
//       queryParameters: {'body': message},
//     );

//     await launchUrl(smsUri);
//   }

//   // ================= TRANSACTIONS =================

//   void addTransaction(String name, Map<String, dynamic> transaction) async {
//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     final customer = _people[index];

//     final txData = {
//       "amount": transaction["amount"],
//       "type": transaction["type"],
//       "note": transaction["note"], // ⭐ MOST IMPORTANT
//       "time": DateTime.now().toIso8601String(),
//     };

//     customer.transactions.add(txData);
//     notifyListeners();

//     await sendSmsIfEnabled(customer, txData);
//   }

//   List<Map<String, dynamic>> getTransactions(String name) {
//     final customer = _people.firstWhere((p) => p.name == name);

//     for (var tx in customer.transactions) {
//       tx.putIfAbsent("time", () => DateTime.now().toIso8601String());
//     }

//     return customer.transactions;
//   }

//   Customer getCustomer(String name) {
//     return _people.firstWhere(
//       (p) => p.name == name,
//       orElse: () =>
//           Customer(name: name, mobile: "", address: "", type: "CUSTOMER"),
//     );
//   }

//   Customer getCustomerByName(String name) {
//     return customers.firstWhere((c) => c.name == name);
//   }
// }

// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/material.dart';

// class Customer {
//   String name;
//   String mobile;
//   String address;
//   String type; // CUSTOMER / SUPPLIER

//   bool smsEnabled;

//   /// ⭐ NEW → CUSTOMER IMAGE (BASE64)
//   String? imageBase64;

//   List<Map<String, dynamic>> transactions = [];

//   Customer({
//     required this.name,
//     required this.mobile,
//     required this.address,
//     required this.type,
//     this.smsEnabled = false,
//     this.imageBase64,
//   });

//   double get balance {
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
// }

// class CustomerProvider extends ChangeNotifier {
//   final List<Customer> _people = [];

//   /// FILTERED LISTS
//   List<Customer> get customers =>
//       _people.where((p) => p.type == "CUSTOMER").toList();

//   List<Customer> get suppliers =>
//       _people.where((p) => p.type == "SUPPLIER").toList();

//   /// ADD PERSON
//   void addPerson(String name, String mobile, String address, String type) {
//     if (_people.any((p) => p.name == name)) return;

//     _people.add(
//       Customer(name: name, mobile: mobile, address: address, type: type),
//     );

//     notifyListeners();
//   }

//   void addCustomer(String name, String mobile, String address) {
//     addPerson(name, mobile, address, "CUSTOMER");
//   }

//   void updateCustomer(
//     String oldName,
//     String name,
//     String mobile,
//     String address,
//   ) {
//     final index = _people.indexWhere((p) => p.name == oldName);
//     if (index == -1) return;

//     _people[index].name = name;
//     _people[index].mobile = mobile;
//     _people[index].address = address;

//     notifyListeners();
//   }

//   void deleteCustomer(String name) {
//     _people.removeWhere((p) => p.name == name);
//     notifyListeners();
//   }

//   /// ⭐⭐⭐ IMAGE FUNCTIONS ⭐⭐⭐

//   void updateCustomerImage(String name, String base64Image) {
//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     _people[index].imageBase64 = base64Image;
//     notifyListeners();
//   }

//   ImageProvider? getCustomerImage(Customer customer) {
//     if (customer.imageBase64 == null) return null;
//     return MemoryImage(base64Decode(customer.imageBase64!));
//   }

//   /// ⭐ TOGGLE SMS
//   void toggleCustomerSMS(Customer customer, bool value) {
//     customer.smsEnabled = value;
//     notifyListeners();
//   }

//   // ================= SMS FUNCTION =================

//   Future<void> sendSmsIfEnabled(
//     Customer customer,
//     Map<String, dynamic> tx,
//   ) async {
//     if (!customer.smsEnabled) return;

//     final amount = tx["amount"];
//     final isGiven = tx["type"] == "GIVEN";

//     String message;

//     if (isGiven) {
//       message =
//           "Hi ${customer.name}, you received ₹$amount from me. - SmartBahi";
//     } else {
//       message =
//           "Hi ${customer.name}, you paid ₹$amount. Thank you! - SmartBahi";
//     }

//     final Uri smsUri = Uri(
//       scheme: 'sms',
//       path: customer.mobile,
//       queryParameters: {'body': message},
//     );

//     await launchUrl(smsUri);
//   }

//   // ================= TRANSACTIONS =================

//   void addTransaction(String name, Map<String, dynamic> transaction) async {
//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     final customer = _people[index];

//     final txData = {
//       "amount": transaction["amount"],
//       "type": transaction["type"],
//       "note": transaction["note"],
//       "time": DateTime.now().toIso8601String(),
//     };

//     customer.transactions.add(txData);
//     notifyListeners();

//     await sendSmsIfEnabled(customer, txData);
//   }

//   /// ⭐ APPLY DISCOUNT
//   void applyDiscount(String name, double amount) {
//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     _people[index].transactions.add({
//       "amount": amount,
//       "type": "RECEIVED", // discount = paise mile (balance kam hoga)
//       "note": "Discount Given",
//       "time": DateTime.now().toIso8601String(),
//     });

//     notifyListeners();
//   }

//   List<Map<String, dynamic>> getTransactions(String name) {
//     final customer = _people.firstWhere((p) => p.name == name);

//     for (var tx in customer.transactions) {
//       tx.putIfAbsent("time", () => DateTime.now().toIso8601String());
//     }

//     return customer.transactions;
//   }

//   Customer getCustomer(String name) {
//     return _people.firstWhere(
//       (p) => p.name == name,
//       orElse: () =>
//           Customer(name: name, mobile: "", address: "", type: "CUSTOMER"),
//     );
//   }

//   Customer getCustomerByName(String name) {
//     return customers.firstWhere((c) => c.name == name);
//   }

//   Future<void> callCustomer(Customer customer) async {
//     final Uri callUri = Uri(scheme: 'tel', path: customer.mobile);

//     await launchUrl(callUri);
//   }

//   /// ⭐ SET AUTO REMINDER PLAN
//   void setAutoReminder(String name, int days) {
//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     _people[index].reminderStartDate = DateTime.now();
//     _people[index].reminderDays = days;

//     notifyListeners();
//   }

//   /// ⭐ CHECK & SEND AUTO REMINDER
//   Future<void> checkAutoReminders() async {
//     for (var customer in _people) {
//       if (customer.reminderStartDate == null || customer.reminderDays == null)
//         continue;
//       if (customer.balance <= 0) continue;

//       final start = customer.reminderStartDate!;
//       final days = customer.reminderDays!;
//       final now = DateTime.now();

//       final diff = now.difference(start).inDays;

//       if (diff >= days) {
//         final message =
//             "Reminder: Hi ${customer.name}, please pay ₹${customer.balance.abs().toStringAsFixed(0)}. - SmartBahi";

//         final Uri smsUri = Uri(
//           scheme: 'sms',
//           path: customer.mobile,
//           queryParameters: {'body': message},
//         );

//         await launchUrl(smsUri);

//         /// reset reminder again for next cycle
//         customer.reminderStartDate = DateTime.now();
//       }
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Customer {
  String name;
  String mobile;
  String address;
  String type;
  bool smsEnabled;
  String? imageBase64;

  DateTime? reminderStartDate;
  int? reminderDays;

  List<Map<String, dynamic>> transactions = [];

  Customer({
    required this.name,
    required this.mobile,
    required this.address,
    required this.type,
    this.smsEnabled = false,
    this.imageBase64,
    this.reminderStartDate,
    this.reminderDays,
  });

  double get balance {
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
}

class CustomerProvider extends ChangeNotifier {
  final List<Customer> _people = [];

  List<Customer> get customers =>
      _people.where((p) => p.type == "CUSTOMER").toList();

  List<Customer> get suppliers =>
      _people.where((p) => p.type == "SUPPLIER").toList();

  // ================= BASIC CRUD =================

  void addCustomer(String name, String mobile, String address) {
    addPerson(name, mobile, address, "CUSTOMER");
  }

  void addPerson(String name, String mobile, String address, String type) {
    if (_people.any((p) => p.name == name)) return;
    _people.add(
      Customer(name: name, mobile: mobile, address: address, type: type),
    );
    notifyListeners();
  }

  void updateCustomer(
    String oldName,
    String name,
    String mobile,
    String address,
  ) {
    final index = _people.indexWhere((p) => p.name == oldName);
    if (index == -1) return;
    _people[index].name = name;
    _people[index].mobile = mobile;
    _people[index].address = address;
    notifyListeners();
  }

  void deleteCustomer(String name) {
    _people.removeWhere((p) => p.name == name);
    notifyListeners();
  }

  Customer getCustomer(String name) =>
      _people.firstWhere((p) => p.name == name);

  Customer getCustomerByName(String name) =>
      customers.firstWhere((c) => c.name == name);

  // ================= IMAGE =================

  void updateCustomerImage(String name, String base64Image) {
    final index = _people.indexWhere((p) => p.name == name);
    if (index == -1) return;
    _people[index].imageBase64 = base64Image;
    notifyListeners();
  }

  ImageProvider? getCustomerImage(Customer customer) {
    if (customer.imageBase64 == null) return null;
    return MemoryImage(base64Decode(customer.imageBase64!));
  }

  // ================= SMS SETTINGS =================

  void toggleCustomerSMS(Customer customer, bool value) {
    customer.smsEnabled = value;
    notifyListeners();
  }

  // ================= TRANSACTIONS =================

  void addTransaction(String name, Map<String, dynamic> transaction) async {
    final index = _people.indexWhere((p) => p.name == name);
    if (index == -1) return;

    final txData = {
      "amount": transaction["amount"],
      "type": transaction["type"],
      "note": transaction["note"],
      "time": DateTime.now().toIso8601String(),
    };

    _people[index].transactions.add(txData);
    notifyListeners();
  }

  List<Map<String, dynamic>> getTransactions(String name) {
    final customer = _people.firstWhere((p) => p.name == name);
    return customer.transactions;
  }

  // ================= DISCOUNT =================

  void applyDiscount(String name, double amount) {
    final index = _people.indexWhere((p) => p.name == name);
    if (index == -1) return;

    _people[index].transactions.add({
      "amount": amount,
      "type": "RECEIVED",
      "note": "Discount Given",
      "time": DateTime.now().toIso8601String(),
    });

    notifyListeners();
  }

  // ================= CALL =================

  Future<void> callCustomer(Customer customer) async {
    final Uri callUri = Uri(scheme: 'tel', path: customer.mobile);
    await launchUrl(callUri);
  }

  // ================= AUTO REMINDER =================

  void setAutoReminder(String name, int days) {
    final index = _people.indexWhere((p) => p.name == name);
    if (index == -1) return;

    _people[index].reminderStartDate = DateTime.now();
    _people[index].reminderDays = days;
    notifyListeners();
  }

  Future<void> checkAutoReminders() async {
    for (var customer in _people) {
      if (customer.reminderStartDate == null || customer.reminderDays == null)
        continue;
      if (customer.balance <= 0) continue;

      final diff = DateTime.now()
          .difference(customer.reminderStartDate!)
          .inDays;

      if (diff >= customer.reminderDays!) {
        final Uri smsUri = Uri(
          scheme: 'sms',
          path: customer.mobile,
          queryParameters: {
            'body':
                "Reminder: Hi ${customer.name}, please pay ₹${customer.balance.abs().toStringAsFixed(0)} - SmartBahi",
          },
        );

        await launchUrl(smsUri);
        customer.reminderStartDate = DateTime.now();
      }
    }
  }
}
