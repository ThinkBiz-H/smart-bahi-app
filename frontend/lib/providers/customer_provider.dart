// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:frontend/models/customer_model.dart';
// import '../services/api_service.dart';
// import 'package:hive/hive.dart';

// class CustomerProvider extends ChangeNotifier {
//   // ================= PLAN SYSTEM =================

//   bool _isPremium = false;
//   int dailyTransactionLimit = 2;

//   bool get isPremium => _isPremium;

//   void activatePremium() {
//     _isPremium = true;
//     notifyListeners();
//   }

//   Future loadCustomers(String mobile) async {
//     final data = await ApiService.getCustomers(mobile);

//     _people.clear();

//     for (var c in data) {
//       _people.add(
//         Customer(
//           name: c["name"],
//           mobile: c["mobile"],
//           address: c["address"] ?? "",
//           type: c["type"] ?? "CUSTOMER",
//         ),
//       );
//     }

//     notifyListeners();
//   }

//   int getTodayTransactionCount() {
//     int count = 0;

//     final today = DateTime.now();

//     for (var person in _people) {
//       for (var t in person.transactions) {
//         DateTime time = DateTime.parse(t["time"]);

//         if (time.year == today.year &&
//             time.month == today.month &&
//             time.day == today.day) {
//           count++;
//         }
//       }
//     }

//     return count;
//   }

//   bool canAddTransaction() {
//     if (_isPremium) return true;

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

//   Future addCustomer(
//     String name,
//     String mobile,
//     String address,
//     String type,
//   ) async {
//     final settings = Hive.box('settings');
//     final ownerMobile = settings.get('mobile');

//     final res = await ApiService.addCustomer({
//       "ownerMobile": ownerMobile,
//       "name": name,
//       "mobile": mobile,
//       "address": address,
//       "type": type,
//     });

//     if (res["success"] == true) {
//       _people.add(
//         Customer(name: name, mobile: mobile, address: address, type: type),
//       );

//       notifyListeners();
//     }
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
//         backend connnect //
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:frontend/models/customer_model.dart';
// import '../services/api_service.dart';
// import 'package:hive/hive.dart';

// class CustomerProvider extends ChangeNotifier {
//   bool _isPremium = false;
//   int dailyTransactionLimit = 2;

//   bool get isPremium => _isPremium;

//   void activatePremium() {
//     _isPremium = true;
//     notifyListeners();
//   }

//   /// BUSINESS

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

//   /// PEOPLE

//   final List<Customer> _people = [];

//   List<Customer> get customers =>
//       _people.where((p) => p.type == "CUSTOMER").toList();

//   List<Customer> get suppliers =>
//       _people.where((p) => p.type == "SUPPLIER" && !p.isHidden).toList();

//   List<Customer> get allSuppliers =>
//       _people.where((p) => p.type == "SUPPLIER").toList();

//   List<Customer> get hiddenSuppliers =>
//       _people.where((p) => p.type == "SUPPLIER" && p.isHidden).toList();

//   /// LOAD CUSTOMERS

//   Future loadCustomers(String mobile) async {
//     final res = await ApiService.getCustomers(mobile);

//     _people.clear();

//     if (res["success"] == true) {
//       List list = res["data"];

//       for (var c in list) {
//         _people.add(
//           Customer(
//             id: c["_id"] ?? "",
//             name: c["name"] ?? "",
//             mobile: c["mobile"] ?? "",
//             address: c["address"] ?? "",
//             type: c["type"] == "SUPPLIER" ? "SUPPLIER" : "CUSTOMER",
//             imageBase64: c["imageBase64"],
//           ),
//         );
//       }
//     }

//     notifyListeners();
//   }

//   /// LOAD TRANSACTIONS

//   Future loadTransactions(String customerId, String name) async {
//     final res = await ApiService.getTransactions(customerId);

//     final customer = getCustomer(name);

//     customer.transactions.clear();

//     if (res["data"] != null) {
//       for (var t in res["data"]) {
//         customer.transactions.add({
//           "amount": t["amount"],
//           "type": t["type"] == "gave" ? "GIVEN" : "RECEIVED",
//           "note": t["note"] ?? "",
//           "time": t["createdAt"] ?? DateTime.now().toIso8601String(),
//         });
//       }
//     }

//     notifyListeners();
//   }

//   /// ADD CUSTOMER

//   Future addCustomer(
//     String name,
//     String mobile,
//     String address,
//     String type,
//   ) async {
//     final settings = Hive.box('settings');
//     final ownerMobile = settings.get('mobile');

//     final res = await ApiService.addCustomer({
//       "ownerMobile": ownerMobile,
//       "name": name,
//       "mobile": mobile,
//       "address": address,
//       "type": type,
//     });

//     if (res["data"] != null) {
//       final data = res["data"];

//       _people.add(
//         Customer(
//           id: data["_id"],
//           name: data["name"],
//           mobile: data["mobile"],
//           address: data["address"] ?? "",
//           type: data["type"] ?? "CUSTOMER",
//           imageBase64: data["imageBase64"],
//         ),
//       );

//       notifyListeners();
//     }
//   }

//   Future sendTransactionSMS(
//     Customer customer,
//     double amount,
//     String type,
//   ) async {
//     if (!customer.smsEnabled) return;

//     final message =
//         "Hi ${customer.name},\n"
//         "₹$amount ${type == "GIVEN" ? "udhaar diya" : "paisa mila"}.\n"
//         "SmartBahi";

//     final Uri smsUri = Uri(
//       scheme: 'sms',
//       path: customer.mobile,
//       queryParameters: {'body': message},
//     );

//     await launchUrl(smsUri);
//   }

//   /// ADD PERSON (LOCAL)

//   void addPerson(String name, String mobile, String address, String type) {
//     _people.add(
//       Customer(
//         id: "",
//         name: name,
//         mobile: mobile,
//         address: address,
//         type: type,
//       ),
//     );

//     notifyListeners();
//   }

//   /// UPDATE CUSTOMER

//   Future updateCustomer(
//     String id,
//     String name,
//     String mobile,
//     String address,
//   ) async {
//     final res = await ApiService.updateCustomer(id, {
//       "name": name,
//       "mobile": mobile,
//       "address": address,
//     });

//     if (res["success"] == true) {
//       final index = _people.indexWhere((p) => p.id == id);

//       if (index != -1) {
//         _people[index].name = name;
//         _people[index].mobile = mobile;
//         _people[index].address = address;
//       }

//       notifyListeners();
//     }
//   }

//   /// DELETE CUSTOMER

//   Future deleteCustomer(String name) async {
//     final customer = getCustomer(name);

//     await ApiService.deleteCustomer(customer.id);

//     _people.removeWhere((p) => p.name == name);

//     notifyListeners();
//   }

//   /// GET CUSTOMER

//   Customer getCustomer(String name) {
//     return _people.firstWhere(
//       (p) => p.name == name,
//       orElse: () => Customer(
//         id: "",
//         name: name,
//         mobile: "",
//         address: "",
//         type: "CUSTOMER",
//       ),
//     );
//   }

//   /// IMAGE

//   Future updateCustomerImage(String name, String base64Image) async {
//     final customer = getCustomer(name);

//     final res = await ApiService.updateCustomer(customer.id, {
//       "imageBase64": base64Image,
//     });

//     if (res["success"] == true) {
//       customer.imageBase64 = base64Image;

//       notifyListeners();
//     }
//   }

//   ImageProvider? getCustomerImage(Customer customer) {
//     if (customer.imageBase64 == null) return null;

//     return MemoryImage(base64Decode(customer.imageBase64!));
//   }

//   /// SMS

//   void toggleCustomerSMS(Customer customer, bool value) {
//     customer.smsEnabled = value;

//     notifyListeners();
//   }

//   /// TRANSACTION

//   Future addTransaction(String name, Map transaction) async {
//     final settings = Hive.box('settings');
//     final ownerMobile = settings.get('mobile');

//     final customer = getCustomer(name);

//     final res = await ApiService.addTransaction({
//       "ownerMobile": ownerMobile,
//       "customerId": customer.id,
//       "type": transaction["type"] == "GIVEN" ? "gave" : "received",
//       "amount": transaction["amount"],
//       "note": transaction["note"],
//     });

//     if (res != null) {
//       /// LOCAL TRANSACTION ADD
//       customer.transactions.add({
//         "amount": transaction["amount"],
//         "type": transaction["type"],
//         "note": transaction["note"],
//         "time": DateTime.now().toIso8601String(),
//       });

//       notifyListeners();

//       /// ⭐ SMS SEND (ONLY IF ENABLED)
//       if (customer.smsEnabled) {
//         final message =
//             "Hi ${customer.name},\n"
//             "₹${transaction["amount"]} ${transaction["type"] == "GIVEN" ? "udhaar diya" : "paisa mila"}.\n"
//             "SmartBahi";

//         final Uri smsUri = Uri(
//           scheme: 'sms',
//           path: customer.mobile,
//           queryParameters: {'body': message},
//         );

//         await launchUrl(smsUri);
//       }
//     }
//   }

//   List<Map<String, dynamic>> getTransactions(String name) {
//     final customer = getCustomer(name);

//     return customer.transactions;
//   }

//   /// REMINDER

//   void setDueDate(String name, DateTime date) {
//     final customer = getCustomer(name);

//     customer.dueDate = date;

//     notifyListeners();
//   }

//   void setAutoReminder(String name, int days) {
//     final customer = getCustomer(name);

//     customer.reminderStartDate = DateTime.now();
//     customer.reminderDays = days;

//     notifyListeners();
//   }

//   Future<void> checkAutoReminders() async {
//     final today = DateTime.now();

//     for (var customer in _people) {
//       if (customer.reminderStartDate == null || customer.reminderDays == null) {
//         continue;
//       }

//       final reminderDate = customer.reminderStartDate!.add(
//         Duration(days: customer.reminderDays!),
//       );

//       if (today.year == reminderDate.year &&
//           today.month == reminderDate.month &&
//           today.day == reminderDate.day) {
//         final message =
//             "Hi ${customer.name},\n"
//             "Aapka ₹${customer.balance.abs()} udhaar baki hai.\n"
//             "Kripya payment kar dijiye.\n"
//             "SmartBahi";

//         final Uri smsUri = Uri(
//           scheme: 'sms',
//           path: customer.mobile,
//           queryParameters: {'body': message},
//         );

//         await launchUrl(smsUri);
//       }
//     }
//   }

//   /// LIMIT

//   bool canAddTransaction() {
//     if (_isPremium) return true;

//     return true;
//   }

//   /// CALL

//   Future<void> callCustomer(Customer customer) async {
//     final Uri callUri = Uri(scheme: 'tel', path: customer.mobile);

//     await launchUrl(callUri);
//   }

//   /// DISCOUNT

//   void applyDiscount(String name, double amount) {
//     final customer = getCustomer(name);

//     customer.transactions.add({
//       "amount": amount,
//       "type": "RECEIVED",
//       "note": "Discount Given",
//       "time": DateTime.now().toIso8601String(),
//     });

//     notifyListeners();
//   }

//   /// HIDE SUPPLIER

//   void toggleHidden(Customer customer, bool value) {
//     customer.isHidden = value;

//     notifyListeners();
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/models/customer_model.dart';
import '../services/api_service.dart';
import 'package:hive/hive.dart';
import 'package:telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomerProvider extends ChangeNotifier {
  final Telephony telephony = Telephony.instance;
  Future<bool> requestSmsPermission() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  Future<void> sendSMS(String mobile, String message) async {
    bool granted = await requestSmsPermission();

    if (!granted) return;

    await telephony.sendSms(to: mobile, message: message);
  }

  bool _isPremium = false;
  int dailyTransactionLimit = 2;

  bool get isPremium => _isPremium;

  void activatePremium() {
    _isPremium = true;
    notifyListeners();
  }

  /// ================= BUSINESS =================

  String _businessName = "My Business";
  String _businessPhone = "";
  String? _businessImageBase64;
  bool _isBusinessCreated = false;

  String get businessName => _businessName;
  String get businessPhone => _businessPhone;
  bool get isBusinessCreated => _isBusinessCreated;

  ImageProvider? get businessImage {
    if (_businessImageBase64 == null || _businessImageBase64!.isEmpty) {
      return null;
    }
    return MemoryImage(base64Decode(_businessImageBase64!));
  }

  void loadBusinessProfile() {
    final box = Hive.box('settings');

    _businessName = box.get("businessName", defaultValue: "My Business");
    _businessPhone = box.get("mobile", defaultValue: "");
    _businessImageBase64 = box.get("businessImage");

    _isBusinessCreated = true;

    notifyListeners();
  }

  void updateBusinessProfile({
    required String name,
    required String phone,
    String? base64Image,
  }) {
    final box = Hive.box('settings');

    _businessName = name;
    _businessPhone = phone;

    box.put("businessName", name);
    box.put("mobile", phone);

    if (base64Image != null) {
      _businessImageBase64 = base64Image;
      box.put("businessImage", base64Image);
    }

    _isBusinessCreated = true;

    notifyListeners();
  }

  /// ================= PEOPLE =================

  final List<Customer> _people = [];

  List<Customer> get customers =>
      _people.where((p) => p.type == "CUSTOMER").toList();

  List<Customer> get suppliers =>
      _people.where((p) => p.type == "SUPPLIER" && !p.isHidden).toList();

  List<Customer> get allSuppliers =>
      _people.where((p) => p.type == "SUPPLIER").toList();

  List<Customer> get hiddenSuppliers =>
      _people.where((p) => p.type == "SUPPLIER" && p.isHidden).toList();

  /// ================= LOAD CUSTOMERS =================

  Future loadCustomers(String mobile) async {
    final res = await ApiService.getCustomers(mobile);

    _people.clear();

    if (res != null && res["success"] == true) {
      List list = res["data"];

      for (var c in list) {
        _people.add(
          Customer(
            id: c["_id"] ?? "",
            name: c["name"] ?? "",
            mobile: c["mobile"] ?? "",
            address: c["address"] ?? "",
            type: c["type"] == "SUPPLIER" ? "SUPPLIER" : "CUSTOMER",
            imageBase64: c["imageBase64"] ?? "",
          ),
        );
      }
    }

    notifyListeners();
  }

  Future loadTransactions(String customerId, String name) async {
    final res = await ApiService.getTransactions(customerId);

    final customer = getCustomer(name);

    customer.transactions.clear();

    if (res != null && res["data"] != null) {
      for (var t in res["data"]) {
        customer.transactions.add({
          "amount": t["amount"],
          "type": t["type"] == "gave" ? "GIVEN" : "RECEIVED",
          "note": t["note"] ?? "",
          "time": t["createdAt"] ?? DateTime.now().toIso8601String(),
        });
      }
    }

    notifyListeners();
  }

  /// ================= ADD PERSON LOCAL =================

  void addPerson(String name, String mobile, String address, String type) {
    _people.add(
      Customer(
        id: "",
        name: name,
        mobile: mobile,
        address: address,
        type: type,
      ),
    );

    notifyListeners();
  }

  /// ================= ADD CUSTOMER =================

  Future addCustomer(
    String name,
    String mobile,
    String address,
    String type,
  ) async {
    final settings = Hive.box('settings');
    final ownerMobile = settings.get('mobile');

    final res = await ApiService.addCustomer({
      "ownerMobile": ownerMobile,
      "name": name,
      "mobile": mobile,
      "address": address,
      "type": type,
    });

    if (res != null && res["data"] != null) {
      final data = res["data"];

      _people.add(
        Customer(
          id: data["_id"],
          name: data["name"],
          mobile: data["mobile"],
          address: data["address"] ?? "",
          type: data["type"] ?? "CUSTOMER",
          imageBase64: data["imageBase64"] ?? "",
        ),
      );

      notifyListeners();
    }
  }

  /// ================= GET CUSTOMER =================

  Customer getCustomer(String name) {
    return _people.firstWhere(
      (p) => p.name == name,
      orElse: () => Customer(
        id: "",
        name: name,
        mobile: "",
        address: "",
        type: "CUSTOMER",
      ),
    );
  }

  /// ================= DELETE CUSTOMER =================

  Future deleteCustomer(String name) async {
    final customer = getCustomer(name);

    if (customer.id.isEmpty) return;

    await ApiService.deleteCustomer(customer.id);

    _people.removeWhere((p) => p.name == name);

    notifyListeners();
  }

  /// ================= UPDATE CUSTOMER =================

  Future updateCustomer(
    String id,
    String name,
    String mobile,
    String address,
  ) async {
    final res = await ApiService.updateCustomer(id, {
      "name": name,
      "mobile": mobile,
      "address": address,
    });

    if (res != null && res["success"] == true) {
      final index = _people.indexWhere((p) => p.id == id);

      if (index != -1) {
        _people[index].name = name;
        _people[index].mobile = mobile;
        _people[index].address = address;
      }

      notifyListeners();
    }
  }

  /// ================= IMAGE =================

  Future updateCustomerImage(String name, String base64Image) async {
    final customer = getCustomer(name);

    if (customer.id.isEmpty) return;

    final res = await ApiService.updateCustomer(customer.id, {
      "imageBase64": base64Image,
    });

    if (res != null && res["success"] == true) {
      customer.imageBase64 = base64Image;

      notifyListeners();
    }
  }

  ImageProvider? getCustomerImage(Customer customer) {
    if (customer.imageBase64 == null || customer.imageBase64!.isEmpty) {
      return null;
    }

    return MemoryImage(base64Decode(customer.imageBase64!));
  }

  /// ================= SMS =================

  void toggleCustomerSMS(Customer customer, bool value) {
    customer.smsEnabled = value;

    notifyListeners();
  }

  /// ================= TRANSACTION =================

  Future addTransaction(String name, Map transaction) async {
    final settings = Hive.box('settings');
    final ownerMobile = settings.get('mobile');

    final customer = getCustomer(name);

    if (customer.id.isEmpty) return;

    final res = await ApiService.addTransaction({
      "ownerMobile": ownerMobile,
      "customerId": customer.id,
      "type": transaction["type"] == "GIVEN" ? "gave" : "received",
      "amount": transaction["amount"],
      "note": transaction["note"],
    });

    if (res != null) {
      customer.transactions.add({
        "amount": transaction["amount"],
        "type": transaction["type"],
        "note": transaction["note"],
        "time": DateTime.now().toIso8601String(),
      });

      notifyListeners();

      if (customer.smsEnabled) {
        final message =
            "Hi ${customer.name},\n"
            "₹${transaction["amount"]} ${transaction["type"] == "GIVEN" ? "udhaar diya" : "paisa mila"}.\n"
            "SmartBahi";

        // final Uri smsUri = Uri(
        //   scheme: 'sms',
        //   path: customer.mobile,
        //   queryParameters: {'body': message},
        // );
        await sendSMS(customer.mobile, message);

        // await launchUrl(smsUri);
        // await sendSMS(customer.mobile, message);
      }
    }
  }

  List<Map<String, dynamic>> getTransactions(String name) {
    final customer = getCustomer(name);

    return customer.transactions;
  }

  /// ================= TRANSACTION LIMIT =================

  bool canAddTransaction() {
    if (_isPremium) return true;

    return true;
  }

  /// ================= REMINDER =================

  void setDueDate(String name, DateTime date) {
    final customer = getCustomer(name);

    customer.dueDate = date;

    notifyListeners();
  }

  void setAutoReminder(String name, int days) {
    final customer = getCustomer(name);

    customer.reminderStartDate = DateTime.now();
    customer.reminderDays = days;

    notifyListeners();
  }

  Future<void> checkAutoReminders() async {
    final today = DateTime.now();

    for (var customer in _people) {
      if (customer.reminderStartDate == null || customer.reminderDays == null)
        continue;

      final reminderDate = customer.reminderStartDate!.add(
        Duration(days: customer.reminderDays!),
      );

      if (today.year == reminderDate.year &&
          today.month == reminderDate.month &&
          today.day == reminderDate.day) {
        final message =
            "Hi ${customer.name},\n"
            "Aapka ₹${customer.balance.abs()} udhaar baki hai.\n"
            "Kripya payment kar dijiye.\n"
            "SmartBahi";

        final Uri smsUri = Uri(
          scheme: 'sms',
          path: customer.mobile,
          queryParameters: {'body': message},
        );

        // await launchUrl(smsUri);
        await sendSMS(customer.mobile, message);
      }
    }
  }

  /// ================= CALL =================

  Future<void> callCustomer(Customer customer) async {
    final Uri callUri = Uri(scheme: 'tel', path: customer.mobile);

    await launchUrl(callUri);
  }

  /// ================= DISCOUNT =================

  void applyDiscount(String name, double amount) {
    final customer = getCustomer(name);

    customer.transactions.add({
      "amount": amount,
      "type": "RECEIVED",
      "note": "Discount Given",
      "time": DateTime.now().toIso8601String(),
    });

    notifyListeners();
  }

  /// ================= HIDE =================

  void toggleHidden(Customer customer, bool value) {
    customer.isHidden = value;

    notifyListeners();
  }
}
