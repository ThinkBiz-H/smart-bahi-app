// import 'package:flutter/material.dart';
// import '../../../core/services/payment_service.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';

// class PlanScreen extends StatefulWidget {
//   const PlanScreen({super.key});

//   @override
//   State<PlanScreen> createState() => _PlanScreenState();
// }

// class _PlanScreenState extends State<PlanScreen> {
//   int selectedPlan = 0;

//   final PaymentService paymentService = PaymentService();

//   @override
//   void initState() {
//     super.initState();

//     /// SAFE INIT
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       paymentService.init(
//         context,
//         onSuccess: () {
//           Provider.of<CustomerProvider>(
//             context,
//             listen: false,
//           ).activatePremium();

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Plan activated successfully")),
//           );

//           Navigator.pop(context);
//         },
//       );
//     });
//   }

//   @override
//   void dispose() {
//     paymentService.dispose();
//     super.dispose();
//   }

//   int getPrice() {
//     if (selectedPlan == 1) return 30;
//     if (selectedPlan == 2) return 99;
//     return 75;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Plans")),
//       body: Column(
//         children: [
//           /// INFO BANNER
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.teal.shade100,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.handshake, color: Colors.teal),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     "Be assured. Plan prices will never increase!",
//                     style: TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               children: [
//                 _planCard(
//                   index: 0,
//                   title: "Ads Free++",
//                   price: "₹75 for 30 days",
//                   active: true,
//                   expiry: "Expires on 22 Feb, 2026",
//                   benefits: const ["Unlimited Transactions", "No Ads"],
//                 ),
//                 _planCard(
//                   index: 1,
//                   title: "Unlimited Transactions",
//                   price: "₹30 for 30 days",
//                   benefits: const [
//                     "Unlimited Daily Ledger Transactions",
//                     "Contain Ads",
//                   ],
//                 ),
//                 _planCard(
//                   index: 2,
//                   title: "Premium",
//                   price: "₹99 for 30 days",
//                   benefits: const [
//                     "All Benefits of Ads Free++",
//                     "Unlimited transaction SMS",
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           /// PAYMENT BUTTON
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF0C2752),
//                 minimumSize: const Size(double.infinity, 55),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               onPressed: () {
//                 int price = getPrice();
//                 paymentService.openCheckout(price);
//               },
//               child: const Text(
//                 "Extend Plan (+30 days)",
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _planCard({
//     required int index,
//     required String title,
//     required String price,
//     bool active = false,
//     String? expiry,
//     required List<String> benefits,
//   }) {
//     final isSelected = selectedPlan == index;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedPlan = index;
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: isSelected ? const Color(0xFF0C2752) : Colors.grey.shade300,
//             width: 2,
//           ),
//           color: Colors.grey.shade100,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.workspace_premium),
//                 const SizedBox(width: 10),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Spacer(),
//                 if (active)
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Text(
//                       "Active",
//                       style: TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   ),
//                 const SizedBox(width: 8),
//                 Icon(
//                   isSelected
//                       ? Icons.radio_button_checked
//                       : Icons.radio_button_off,
//                   color: Colors.green,
//                 ),
//               ],
//             ),

//             const SizedBox(height: 8),

//             Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),

//             if (expiry != null) ...[
//               const SizedBox(height: 4),
//               Text(expiry, style: const TextStyle(color: Colors.orange)),
//             ],

//             const Divider(),

//             ...benefits.map(
//               (b) => Padding(
//                 padding: const EdgeInsets.only(bottom: 6),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.check_circle,
//                       color: Colors.green,
//                       size: 18,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(b),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/services/payment_service.dart';
import '../../../services/api_service.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  int selectedPlan = 0;

  final PaymentService paymentService = PaymentService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      paymentService.init(
        context,
        onSuccess: () async {
          final settings = Hive.box('settings');
          final mobile = settings.get('mobile');

          int days = 30;
          int dailyLimit = -1;
          String planName = "pro";

          if (selectedPlan == 0) {
            planName = "adsfree";
          } else if (selectedPlan == 1) {
            planName = "basic";
          } else if (selectedPlan == 2) {
            planName = "premium";
          }

          // 🔥 BACKEND CALL
          final res = await ApiService.activatePlan({
            "mobile": mobile,
            "days": days,
            "dailyLimit": dailyLimit,
            "planName": planName,
          });

          print("PLAN RESPONSE: $res");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Plan activated successfully 🚀")),
          );

          Navigator.pop(context);
        },
      );
    });
  }

  @override
  void dispose() {
    paymentService.dispose();
    super.dispose();
  }

  int getPrice() {
    if (selectedPlan == 1) return 1;
    if (selectedPlan == 2) return 1;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Plans")),
      body: Column(
        children: [
          /// INFO BANNER
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.handshake, color: Colors.teal),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Be assured. Plan prices will never increase!",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _planCard(
                  index: 0,
                  title: "Ads Free++",
                  price: "₹75 for 30 days",
                  active: true,
                  expiry: "Expires on 22 Feb, 2026",
                  benefits: const ["Unlimited Transactions", "No Ads"],
                ),
                _planCard(
                  index: 1,
                  title: "Unlimited Transactions",
                  price: "₹30 for 30 days",
                  benefits: const [
                    "Unlimited Daily Ledger Transactions",
                    "Contain Ads",
                  ],
                ),
                _planCard(
                  index: 2,
                  title: "Premium",
                  price: "₹99 for 30 days",
                  benefits: const [
                    "All Benefits of Ads Free++",
                    "Unlimited transaction SMS",
                  ],
                ),
              ],
            ),
          ),

          /// PAYMENT BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C2752),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                int price = getPrice();
                paymentService.openCheckout(price);
              },
              child: const Text(
                "Extend Plan (+30 days)",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _planCard({
    required int index,
    required String title,
    required String price,
    bool active = false,
    String? expiry,
    required List<String> benefits,
  }) {
    final isSelected = selectedPlan == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF0C2752) : Colors.grey.shade300,
            width: 2,
          ),
          color: Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (active)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Active",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),

            if (expiry != null) ...[
              const SizedBox(height: 4),
              Text(expiry, style: const TextStyle(color: Colors.orange)),
            ],

            const Divider(),

            ...benefits.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(b),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
