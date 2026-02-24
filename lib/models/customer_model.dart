class Customer {
  String name;
  String mobile;
  String address;
  String type; // CUSTOMER / SUPPLIER
  bool smsEnabled; // ⭐⭐⭐ NEW FIELD
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
