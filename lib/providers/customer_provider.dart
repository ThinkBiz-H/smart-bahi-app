
import 'package:flutter/material.dart';

class Customer {
  String name;
  String mobile;
  String address;
  String type; // CUSTOMER / SUPPLIER
  List<Map<String, dynamic>> transactions = [];

  Customer({
    required this.name,
    required this.mobile,
    required this.address,
    required this.type,
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

  /// MAIN ADD METHOD
  void addPerson(String name, String mobile, String address, String type) {
    if (_people.any((p) => p.name == name)) return;

    _people.add(
      Customer(name: name, mobile: mobile, address: address, type: type),
    );

    notifyListeners();
  }

  /// OLD METHOD (Compatibility)
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

  /// TRANSACTIONS
  void addTransaction(String name, Map<String, dynamic> transaction) {
    final index = _people.indexWhere((p) => p.name == name);
    if (index == -1) return;

    _people[index].transactions.add(transaction);
    notifyListeners();
  }

  List<Map<String, dynamic>> getTransactions(String name) {
    final customer = _people.firstWhere((p) => p.name == name);
    return customer.transactions;
  }

  Customer getCustomer(String name) {
    return _people.firstWhere((p) => p.name == name);
  }
}
