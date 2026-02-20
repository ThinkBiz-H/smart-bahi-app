
import 'package:flutter/material.dart';
import '../../../core/services/payment_service.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  int selectedPlan = 0; // 0 = AdsFree++ ACTIVE
  final PaymentService paymentService = PaymentService();
  @override
  void initState() {
    super.initState();
    paymentService.init(
      context,
      onSuccess: () {
        // plan activate after payment
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My plans")),
      body: Column(
        children: [
          /// TOP INFO BANNER
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
                  expiry: "Expires on 22 Feb, 2026 (5 days remaining)",
                  benefits: const [
                    "All Benefits of Unlimited Transactions Plan",
                    "No Ads",
                  ],
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
                    "All Benefits of Ads Free++ Plan",
                    "Unlimited transaction SMS from OkCredit",
                  ],
                ),
              ],
            ),
          ),

          /// BOTTOM BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                int price = 75;

                if (selectedPlan == 1) price = 30;
                if (selectedPlan == 2) price = 99;

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

  // PLAN CARD WIDGET
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
      onTap: () => setState(() => selectedPlan = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 2,
          ),
          color: Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER ROW
            Row(
              children: [
                const Icon(Icons.nightlight_round, color: Colors.black87),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),

                /// ACTIVE BADGE
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
                      "Active Plan",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),

                const SizedBox(width: 8),

                /// RADIO CIRCLE
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              price,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            if (expiry != null) ...[
              const SizedBox(height: 6),
              Text(expiry, style: const TextStyle(color: Colors.orange)),
            ],

            const Divider(height: 24),

            /// BENEFITS
            ...benefits.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(b),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            const Row(
              children: [
                Icon(Icons.expand_more, color: Colors.green),
                SizedBox(width: 6),
                Text(
                  "View More",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
