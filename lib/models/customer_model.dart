// class Customer {
//   String name;
//   String mobile;
//   String address;
//   String type;
//   String? imageBase64; // CUSTOMER / SUPPLIER
//   bool smsEnabled; // ⭐⭐⭐ NEW FIELD
//   List<Map<String, dynamic>> transactions = [];

//   Customer({
//     required this.name,
//     required this.mobile,
//     required this.address,
//     required this.type,
//     this.imageBase64,
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

class Customer {
  String name;
  String mobile;
  String address;
  String type;
  bool smsEnabled;
  String? imageBase64;

  /// ⭐ AUTO REMINDER FIELDS ADD
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
