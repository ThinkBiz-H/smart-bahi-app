// import 'package:flutter/material.dart';

// class MultiDeviceScreen extends StatelessWidget {
//   const MultiDeviceScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Multi Device Login")),
//       body: Column(
//         children: [
//           /// 🔒 SECURITY BANNER
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.orange.shade100,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.security, color: Colors.orange),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     "These devices are logged into your account. "
//                     "Logout from any unknown device for safety.",
//                     style: TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           /// DEVICE LIST
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               children: [
//                 _deviceTile(
//                   icon: Icons.phone_android,
//                   name: "Vivo V2307",
//                   location: "Jaipur, India • Active now",
//                   isCurrent: true,
//                 ),
//                 _deviceTile(
//                   icon: Icons.language,
//                   name: "Chrome - Windows",
//                   location: "Jaipur, India • Today 11:30 AM",
//                 ),
//                 _deviceTile(
//                   icon: Icons.phone_android,
//                   name: "Redmi Note 11",
//                   location: "Delhi, India • Yesterday 9:15 PM",
//                 ),
//               ],
//             ),
//           ),

//           /// LOGOUT ALL BUTTON
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 minimumSize: const Size(double.infinity, 55),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               onPressed: () => _logoutAllDialog(context),
//               child: const Text(
//                 "Logout from all devices",
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// DEVICE TILE
//   Widget _deviceTile({
//     required IconData icon,
//     required String name,
//     required String location,
//     bool isCurrent = false,
//   }) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: Colors.green.shade50,
//           child: Icon(icon, color: Colors.green),
//         ),
//         title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
//         subtitle: Text(location),
//         trailing: isCurrent
//             ? Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.green,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text(
//                   "This device",
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               )
//             : TextButton(
//                 onPressed: () {},
//                 child: const Text(
//                   "Logout",
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//       ),
//     );
//   }

//   /// LOGOUT DIALOG
//   void _logoutAllDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Logout from all devices?"),
//         content: const Text(
//           "You will be logged out from all devices including this one.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Logout"),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../services/api_service.dart';

class MultiDeviceScreen extends StatefulWidget {
  const MultiDeviceScreen({super.key});

  @override
  State<MultiDeviceScreen> createState() => _MultiDeviceScreenState();
}

class _MultiDeviceScreenState extends State<MultiDeviceScreen> {
  List devices = [];
  bool loading = true;

  String? mobile;

  @override
  void initState() {
    super.initState();
    loadDevices();
  }

  Future loadDevices() async {
    final box = Hive.box('settings');
    mobile = box.get("mobile");

    final res = await ApiService.getDevices(mobile!);

    if (res["success"] == true) {
      devices = res["data"];
    }

    setState(() {
      loading = false;
    });
  }

  Future logoutDevice(String deviceId) async {
    await ApiService.logoutDevice(deviceId);

    await loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Multi Device Login")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                /// 🔒 SECURITY BANNER
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.security, color: Colors.orange),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "These devices are logged into your account. Logout from any unknown device for safety.",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

                /// DEVICE LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];

                      return _deviceTile(
                        icon:
                            device["deviceName"]
                                .toString()
                                .toLowerCase()
                                .contains("windows")
                            ? Icons.language
                            : Icons.phone_android,

                        name: device["deviceName"] ?? "Unknown Device",

                        location:
                            "${device["location"] ?? "India"} • ${device["lastActive"] ?? ""}",

                        isCurrent: index == 0,

                        onLogout: () {
                          logoutDevice(device["deviceId"]);
                        },
                      );
                    },
                  ),
                ),

                /// LOGOUT ALL BUTTON
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => _logoutAllDialog(context),

                    child: const Text(
                      "Logout from all devices",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  /// DEVICE TILE

  Widget _deviceTile({
    required IconData icon,
    required String name,
    required String location,
    required bool isCurrent,
    required VoidCallback onLogout,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade50,
          child: Icon(icon, color: Colors.green),
        ),

        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),

        subtitle: Text(location),

        trailing: isCurrent
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "This device",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            : TextButton(
                onPressed: onLogout,
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
      ),
    );
  }

  /// LOGOUT ALL

  void _logoutAllDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (_) => AlertDialog(
        title: const Text("Logout from all devices?"),

        content: const Text(
          "You will be logged out from all devices including this one.",
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

            onPressed: () async {
              for (var d in devices) {
                await ApiService.logoutDevice(d["deviceId"]);
              }

              Navigator.pop(context);

              Navigator.pop(context);
            },

            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
