

import 'package:flutter/material.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  int selectedType = 0; // ⭐ 0 = Customer , 1 = Supplier

  void save() {
    if (nameController.text.trim().isEmpty) return;

    Navigator.pop(context, {
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "address": addressController.text.trim(),
      "type": selectedType == 0 ? "CUSTOMER" : "SUPPLIER",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Customer")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// NAME
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Customer Name"),
            ),
            const SizedBox(height: 12),

            /// PHONE
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Mobile Number"),
            ),
            const SizedBox(height: 12),

            /// ADDRESS
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),

            const SizedBox(height: 20),

            /// ⭐ CUSTOMER / SUPPLIER SELECTOR
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedType = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedType == 0
                            ? const Color(0xFF1E8E3E)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Customer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedType == 0
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedType = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedType == 1
                            ? const Color(0xFF1E8E3E)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Supplier",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedType == 1
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            /// CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E8E3E),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: save,
                child: const Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
