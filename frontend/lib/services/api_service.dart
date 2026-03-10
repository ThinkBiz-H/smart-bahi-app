// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   // static const String baseUrl = "http://localhost:5000/api";

//   static const String baseUrl = "http://127.0.0.1:5000/api";

//   /// SEND OTP
//   static Future sendOtp(String mobile) async {
//     final res = await http.post(
//       Uri.parse("$baseUrl/auth/send-otp"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"mobile": mobile}),
//     );

//     return jsonDecode(res.body);
//   }

//   /// VERIFY OTP
//   static Future verifyOtp(String mobile, String otp) async {
//     final res = await http.post(
//       Uri.parse("$baseUrl/auth/verify-otp"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"mobile": mobile, "otp": otp}),
//     );

//     return jsonDecode(res.body);
//   }

//   /// GET CUSTOMERS
//   static Future getCustomers(String mobile) async {
//     final res = await http.get(Uri.parse("$baseUrl/customers/$mobile"));

//     return jsonDecode(res.body);
//   }

//   /// ADD CUSTOMER
//   static Future addCustomer(Map data) async {
//     final res = await http.post(
//       Uri.parse("$baseUrl/customers"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(data),
//     );

//     return jsonDecode(res.body);
//   }

//   /// GET PROFILE
//   static Future getProfile(String mobile) async {
//     final res = await http.get(Uri.parse("$baseUrl/profile/$mobile"));

//     return jsonDecode(res.body);
//   }

//   /// UPDATE PROFILE
//   static Future updateProfile(Map data) async {
//     final res = await http.post(
//       Uri.parse("$baseUrl/profile"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(data),
//     );

//     return jsonDecode(res.body);
//   }

//   /// GET PRODUCTS
//   static Future getProducts(String mobile) async {
//     final res = await http.get(Uri.parse("$baseUrl/products/$mobile"));

//     return jsonDecode(res.body);
//   }

//   /// ADD PRODUCT
//   static Future addProduct(Map data) async {
//     final res = await http.post(
//       Uri.parse("$baseUrl/products"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(data),
//     );

//     return jsonDecode(res.body);
//   }

//   /// DELETE PRODUCT
//   static Future deleteProduct(String code) async {
//     final res = await http.delete(Uri.parse("$baseUrl/products/$code"));

//     return jsonDecode(res.body);
//   }

//   /// ADD TRANSACTION
//   static Future addTransaction(Map data) async {
//     final res = await http.post(
//       Uri.parse("$baseUrl/transactions/add"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(data),
//     );

//     return jsonDecode(res.body);
//   }

//   /// GET CUSTOMER TRANSACTIONS
//   static Future getTransactions(String customerId) async {
//     final res = await http.get(Uri.parse("$baseUrl/transactions/$customerId"));

//     return jsonDecode(res.body);
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  /// ⭐ LOCAL SERVER
  static const String baseUrl = "http://localhost:5000/api";

  static const headers = {"Content-Type": "application/json"};

  /// ================= OTP =================

  static Future sendOtp(String mobile) async {
    final res = await http
        .post(
          Uri.parse("$baseUrl/auth/send-otp"),
          headers: headers,
          body: jsonEncode({"mobile": mobile}),
        )
        .timeout(const Duration(seconds: 10));

    return jsonDecode(res.body);
  }

  static Future verifyOtp(String mobile, String otp) async {
    final res = await http
        .post(
          Uri.parse("$baseUrl/auth/verify-otp"),
          headers: headers,
          body: jsonEncode({"mobile": mobile, "otp": otp}),
        )
        .timeout(const Duration(seconds: 10));

    return jsonDecode(res.body);
  }

  /// ================= CUSTOMERS =================

  static Future getCustomers(String mobile) async {
    final res = await http
        .get(Uri.parse("$baseUrl/customers/$mobile"))
        .timeout(const Duration(seconds: 10));

    return jsonDecode(res.body);
  }

  static Future addCustomer(Map data) async {
    final res = await http
        .post(
          Uri.parse("$baseUrl/customers"),
          headers: headers,
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 10));

    return jsonDecode(res.body);
  }

  static Future updateCustomer(String id, Map data) async {
    final res = await http.put(
      Uri.parse("$baseUrl/customers/$id"),
      headers: headers,
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }

  static Future deleteCustomer(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/customers/$id"));

    return jsonDecode(res.body);
  }

  /// ================= PROFILE =================

  static Future getProfile(String mobile) async {
    final res = await http
        .get(Uri.parse("$baseUrl/profile/$mobile"))
        .timeout(const Duration(seconds: 10));

    return jsonDecode(res.body);
  }

  static Future updateProfile(Map data) async {
    final res = await http
        .post(
          Uri.parse("$baseUrl/profile"),
          headers: headers,
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 10));

    return jsonDecode(res.body);
  }

  /// ================= PRODUCTS =================

  static Future getProducts(String mobile) async {
    final res = await http
        .get(Uri.parse("$baseUrl/products/$mobile"))
        .timeout(const Duration(seconds: 10));

    return jsonDecode(res.body);
  }

  static Future addProduct(Map data) async {
    final res = await http
        .post(
          Uri.parse("$baseUrl/products"),
          headers: headers,
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 10));

    return jsonDecode(res.body);
  }

  static Future deleteProduct(String code) async {
    final res = await http
        .delete(Uri.parse("$baseUrl/products/$code"))
        .timeout(const Duration(seconds: 10));

    return jsonDecode(res.body);
  }

  /// ================= TRANSACTIONS =================

  static Future addTransaction(Map data) async {
    final res = await http
        .post(
          Uri.parse("$baseUrl/transactions/add"),
          headers: headers,
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 10));

    final body = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception(body["message"] ?? "Transaction failed");
    }

    return body;
  }

  static Future getTransactions(String customerId) async {
    final res = await http
        .get(Uri.parse("$baseUrl/transactions/$customerId"))
        .timeout(const Duration(seconds: 10));

    return jsonDecode(res.body);
  }

  /// ================= BILLS =================

  static Future addBill(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/bills"),
      headers: headers,
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }

  static Future getBills(String mobile) async {
    final res = await http.get(Uri.parse("$baseUrl/bills/$mobile"));

    return jsonDecode(res.body);
  }

  static Future updateBill(String id, Map data) async {
    final res = await http.put(
      Uri.parse("$baseUrl/bills/$id"),
      headers: headers,
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }

  static Future deleteBill(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/bills/$id"));

    return jsonDecode(res.body);
  }
}
