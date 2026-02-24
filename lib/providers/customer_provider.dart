// import 'package:flutter/material.dart';

// class Customer {
//   String name;
//   String mobile;
//   String address;
//   String type; // CUSTOMER / SUPPLIER
//   List<Map<String, dynamic>> transactions = [];

//   Customer({
//     required this.name,
//     required this.mobile,
//     required this.address,
//     required this.type,
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

//   /// MAIN ADD METHOD
//   void addPerson(String name, String mobile, String address, String type) {
//     if (_people.any((p) => p.name == name)) return;

//     _people.add(
//       Customer(name: name, mobile: mobile, address: address, type: type),
//     );

//     notifyListeners();
//   }

//   /// OLD METHOD (Compatibility)
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

//   void toggleCustomerSMS(Customer customer, bool value) {
//     customer.smsEnabled = value;
//     notifyListeners();
//   }

//   /// TRANSACTIONS
//   void addTransaction(String name, Map<String, dynamic> transaction) {
//     final index = _people.indexWhere((p) => p.name == name);
//     if (index == -1) return;

//     _people[index].transactions.add({
//       "amount": transaction["amount"],
//       "type": transaction["type"],
//       "time": DateTime.now().toIso8601String(), // ⭐ always save time
//     });

//     notifyListeners();
//   }

//   List<Map<String, dynamic>> getTransactions(String name) {
//     final customer = _people.firstWhere((p) => p.name == name);

//     /// ⭐ OLD DATA AUTO FIX (time inject)
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
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
// import 'package:telephony/telephony.dart';

class Customer {
  String name;
  String mobile;
  String address;
  String type; // CUSTOMER / SUPPLIER

  bool smsEnabled; // ⭐⭐ NEW FIELD ⭐⭐

  List<Map<String, dynamic>> transactions = [];

  Customer({
    required this.name,
    required this.mobile,
    required this.address,
    required this.type,
    this.smsEnabled = false, // ⭐ default OFF
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

  /// FILTERED LISTS
  List<Customer> get customers =>
      _people.where((p) => p.type == "CUSTOMER").toList();

  List<Customer> get suppliers =>
      _people.where((p) => p.type == "SUPPLIER").toList();

  /// ADD PERSON
  void addPerson(String name, String mobile, String address, String type) {
    if (_people.any((p) => p.name == name)) return;

    _people.add(
      Customer(name: name, mobile: mobile, address: address, type: type),
    );

    notifyListeners();
  }

  void addCustomer(String name, String mobile, String address) {
    addPerson(name, mobile, address, "CUSTOMER");
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

  /// ⭐ TOGGLE SMS
  void toggleCustomerSMS(Customer customer, bool value) {
    customer.smsEnabled = value;
    notifyListeners();
  }

  // ================= SMS FUNCTION =================

  // Future<void> sendSmsIfEnabled(
  //   Customer customer,
  //   Map<String, dynamic> tx,
  // ) async {
  //   if (!customer.smsEnabled) return;

  //   final amount = tx["amount"];
  //   final isGiven = tx["type"] == "GIVEN";

  //   String message;

  //   if (isGiven) {
  //     message =
  //         "Hi ${customer.name}, you received ₹$amount from me. - SmartBahi";
  //   } else {
  //     message =
  //         "Hi ${customer.name}, you paid ₹$amount. Thank you! - SmartBahi";
  //   }

  //   await telephony.sendSms(to: customer.mobile, message: message);
  // }
  Future<void> sendSmsIfEnabled(
    Customer customer,
    Map<String, dynamic> tx,
  ) async {
    if (!customer.smsEnabled) return;

    final amount = tx["amount"];
    final isGiven = tx["type"] == "GIVEN";

    String message;

    if (isGiven) {
      message =
          "Hi ${customer.name}, you received ₹$amount from me. - SmartBahi";
    } else {
      message =
          "Hi ${customer.name}, you paid ₹$amount. Thank you! - SmartBahi";
    }

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: customer.mobile,
      queryParameters: {'body': message},
    );

    await launchUrl(smsUri);
  }

  // ================= TRANSACTIONS =================

  void addTransaction(String name, Map<String, dynamic> transaction) async {
    final index = _people.indexWhere((p) => p.name == name);
    if (index == -1) return;

    final customer = _people[index];

    final txData = {
      "amount": transaction["amount"],
      "type": transaction["type"],
      "time": DateTime.now().toIso8601String(),
    };

    /// SAVE
    customer.transactions.add(txData);
    notifyListeners();

    /// 🔥 AUTO SMS SEND
    await sendSmsIfEnabled(customer, txData);
  }

  List<Map<String, dynamic>> getTransactions(String name) {
    final customer = _people.firstWhere((p) => p.name == name);

    for (var tx in customer.transactions) {
      tx.putIfAbsent("time", () => DateTime.now().toIso8601String());
    }

    return customer.transactions;
  }

  Customer getCustomer(String name) {
    return _people.firstWhere(
      (p) => p.name == name,
      orElse: () =>
          Customer(name: name, mobile: "", address: "", type: "CUSTOMER"),
    );
  }

  Customer getCustomerByName(String name) {
    return customers.firstWhere((c) => c.name == name);
  }
}
