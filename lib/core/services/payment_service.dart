
import 'package:flutter/material.dart';

class PaymentService {
  void init(BuildContext context, {required VoidCallback onSuccess}) {}

  void dispose() {}

  void openCheckout(int price) {
    debugPrint("Payment disabled for Web build");
  }
}
