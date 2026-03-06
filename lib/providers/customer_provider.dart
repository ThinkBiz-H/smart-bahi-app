// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:frontend/models/customer_model.dart';

// class CustomerProvider extends ChangeNotifier {
//   // ================= PLAN SYSTEM =================

//   bool isPremiumUser = false;
//   int dailyTransactionLimit = 2;

//   int getTodayTransactionCount() {
//     int count = 0;

//     for (var person in _people) {
//       for (var t in person.transactions) {
//         DateTime time = DateTime.parse(t["time"]);

//         if (time.year == DateTime.now().year &&
//             time.month == DateTime.now().month &&
//             time.day == DateTime.now().day) {
//           count++;
//         }
//       }
//     }

//     return count;
//   }

//   bool canAddTransaction() {
//     if (isPremiumUser) return true;

//     return getTodayTransactionCount() < dailyTransactionLimit;
//   }

//   // ================= BUSINESS PROFILE =================

//   String _businessName = "My Business";
//   String _businessPhone = "";
//   String? _businessImageBase64;
//   bool _isBusinessCreated = false;

//   String get businessName => _businessName;
//   String get businessPhone => _businessPhone;
//   bool get isBusinessCreated => _isBusinessCreated;

//   ImageProvider? get businessImage {
//     if (_businessImageBase64 == null) return null;
//     return MemoryImage(base64Decode(_businessImageBase64!));
//   }

//   void updateBusinessProfile({
//     required String name,
//     required String phone,
//     String? base64Image,
//   }) {
//     _businessName = name;
//     _businessPhone = phone;
//     _isBusinessCreated = true;

//     if (base64Image != null) {
//       _businessImageBase64 = base64Image;
//     }

//     notifyListeners();
//   }

//   // ================= CUSTOMER DATA =================

//   final List<Customer> _people = [];

//   List<Customer> get customers =>
//       _people.where((p) => p.type == "CUSTOMER").toList();

//   List<Customer> get suppliers => _people
//       .where((p) => p.type == "SUPPLIER" && p.isHidden == false)
//       .toList();

//   List<Customer> get hiddenSuppliers =>
//       _people.where((p) => p.type == "SUPPLIER" && p.isHidden == true).toList();

//   List<Customer> get allSuppliers =>
//       _people.where((p) => p.type == "SUPPLIER").toList();

//   // ================= BASIC CRUD =================

//   void addCustomer(String name, String mobile, String address) {
//     addPerson(name, mobile, address, "CUSTOMER");
//   }

//   void addPerson(String name, String mobile, String address, String type) {
//     if (_people.any((p) => p.name == name)) return;

//     _people.add(
//       Customer(name: name, mobile: mobile, address: address, type: type),
//     );

//     notifyListeners();
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

//   Customer getCustomer(String name) =>
//       _people.firstWhere((p) => p.name == name);

//   Customer getCustomerByName(String name) =>
//       customers.firstWhere((c) => c.name == name);

//   // ================= IMAGE =================

//   void updateCustomerImage(String name, String base64Image) {
//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     _people[index].imageBase64 = base64Image;

//     notifyListeners();
//   }

//   void setDueDate(String name, DateTime date) {
//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     _people[index].dueDate = date;

//     notifyListeners();
//   }

//   ImageProvider? getCustomerImage(Customer customer) {
//     if (customer.imageBase64 == null) return null;
//     return MemoryImage(base64Decode(customer.imageBase64!));
//   }

//   // ================= SMS SETTINGS =================

//   void toggleCustomerSMS(Customer customer, bool value) {
//     customer.smsEnabled = value;
//     notifyListeners();
//   }

//   // ================= TRANSACTIONS =================

//   void addTransaction(String name, Map<String, dynamic> transaction) {
//     /// ⭐ LIMIT CHECK
//     if (!canAddTransaction()) {
//       debugPrint("Daily transaction limit reached");
//       return;
//     }

//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     final txData = {
//       "amount": transaction["amount"],
//       "type": transaction["type"],
//       "note": transaction["note"],
//       "time": DateTime.now().toIso8601String(),
//     };

//     _people[index].transactions.add(txData);

//     notifyListeners();
//   }

//   List<Map<String, dynamic>> getTransactions(String name) {
//     final customer = _people.firstWhere((p) => p.name == name);
//     return customer.transactions;
//   }

//   // ================= DISCOUNT =================

//   void applyDiscount(String name, double amount) {
//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     _people[index].transactions.add({
//       "amount": amount,
//       "type": "RECEIVED",
//       "note": "Discount Given",
//       "time": DateTime.now().toIso8601String(),
//     });

//     notifyListeners();
//   }

//   // ================= CALL =================

//   Future<void> callCustomer(Customer customer) async {
//     final Uri callUri = Uri(scheme: 'tel', path: customer.mobile);
//     await launchUrl(callUri);
//   }

//   // ================= HIDE SUPPLIER =================

//   void toggleHidden(Customer customer, bool value) {
//     customer.isHidden = value;
//     notifyListeners();
//   }

//   // ================= AUTO REMINDER =================

//   void setAutoReminder(String name, int days) {
//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     _people[index].reminderStartDate = DateTime.now();
//     _people[index].reminderDays = days;

//     notifyListeners();
//   }

//   void setAutoReminderDate(String name, DateTime date) {
//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     _people[index].reminderStartDate = date;

//     notifyListeners();
//   }

//   Future<void> checkAutoReminders() async {
//     for (var customer in _people) {
//       if (customer.reminderStartDate == null || customer.reminderDays == null)
//         continue;

//       if (customer.balance <= 0) continue;

//       final diff = DateTime.now()
//           .difference(customer.reminderStartDate!)
//           .inDays;

//       if (diff >= customer.reminderDays!) {
//         final Uri smsUri = Uri(
//           scheme: 'sms',
//           path: customer.mobile,
//           queryParameters: {
//             'body':
//                 "Reminder: Hi ${customer.name}, please pay ₹${customer.balance.abs().toStringAsFixed(0)} - SmartBahi",
//           },
//         );

//         await launchUrl(smsUri);

//         customer.reminderStartDate = DateTime.now();
//       }
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/models/customer_model.dart';

class CustomerProvider extends ChangeNotifier {
  // ================= PLAN SYSTEM =================

  bool _isPremium = false;
  int dailyTransactionLimit = 2;

  bool get isPremium => _isPremium;

  void activatePremium() {
    _isPremium = true;
    notifyListeners();
  }

  int getTodayTransactionCount() {
    int count = 0;

    final today = DateTime.now();

    for (var person in _people) {
      for (var t in person.transactions) {
        DateTime time = DateTime.parse(t["time"]);

        if (time.year == today.year &&
            time.month == today.month &&
            time.day == today.day) {
          count++;
        }
      }
    }

    return count;
  }

  bool canAddTransaction() {
    if (_isPremium) return true;

    return getTodayTransactionCount() < dailyTransactionLimit;
  }

  // ================= BUSINESS PROFILE =================

  String _businessName = "My Business";
  String _businessPhone = "";
  String? _businessImageBase64;
  bool _isBusinessCreated = false;

  String get businessName => _businessName;
  String get businessPhone => _businessPhone;
  bool get isBusinessCreated => _isBusinessCreated;

  ImageProvider? get businessImage {
    if (_businessImageBase64 == null) return null;
    return MemoryImage(base64Decode(_businessImageBase64!));
  }

  void updateBusinessProfile({
    required String name,
    required String phone,
    String? base64Image,
  }) {
    _businessName = name;
    _businessPhone = phone;
    _isBusinessCreated = true;

    if (base64Image != null) {
      _businessImageBase64 = base64Image;
    }

    notifyListeners();
  }

  // ================= CUSTOMER DATA =================

  final List<Customer> _people = [];

  List<Customer> get customers =>
      _people.where((p) => p.type == "CUSTOMER").toList();

  List<Customer> get suppliers => _people
      .where((p) => p.type == "SUPPLIER" && p.isHidden == false)
      .toList();

  List<Customer> get hiddenSuppliers =>
      _people.where((p) => p.type == "SUPPLIER" && p.isHidden == true).toList();

  List<Customer> get allSuppliers =>
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

  void setDueDate(String name, DateTime date) {
    final index = _people.indexWhere((p) => p.name == name);
    if (index == -1) return;

    _people[index].dueDate = date;

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

  void addTransaction(String name, Map<String, dynamic> transaction) {
    /// ⭐ LIMIT CHECK
    if (!canAddTransaction()) {
      debugPrint("Daily transaction limit reached");
      return;
    }

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

  // ================= HIDE SUPPLIER =================

  void toggleHidden(Customer customer, bool value) {
    customer.isHidden = value;
    notifyListeners();
  }

  // ================= AUTO REMINDER =================

  void setAutoReminder(String name, int days) {
    final index = _people.indexWhere((p) => p.name == name);
    if (index == -1) return;

    _people[index].reminderStartDate = DateTime.now();
    _people[index].reminderDays = days;

    notifyListeners();
  }

  void setAutoReminderDate(String name, DateTime date) {
    final index = _people.indexWhere((p) => p.name == name);
    if (index == -1) return;

    _people[index].reminderStartDate = date;

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
