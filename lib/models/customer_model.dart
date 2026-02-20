class CustomerModel {
  final String name;
  final List<Map<String, dynamic>> transactions;

  CustomerModel({required this.name, List<Map<String, dynamic>>? transactions})
    : transactions = transactions ?? [];

  double get balance {
    double total = 0;
    for (var t in transactions) {
      if (t['type'] == 'GIVEN') {
        total += t['amount'];
      } else {
        total -= t['amount'];
      }
    }
    return total;
  }
}
