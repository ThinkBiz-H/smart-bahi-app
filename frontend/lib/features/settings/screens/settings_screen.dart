// import 'package:flutter/material.dart';
// import '../../profile/screens/multi_device_screen.dart';
// import 'package:provider/provider.dart';
// import '../../../core/providers/language_provider.dart';
// import '../../../core/language/app_text.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   bool backupEnabled = true;
//   bool appLockEnabled = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppText.of(context, 'settings')),
//       ), // ⭐ comma fix

//       body: ListView(
//         children: [
//           _tile(Icons.language, "Language", "English", _chooseLanguage),
//           _tile(Icons.phone, "Change Mobile Number", "", _changeNumber),

//           _switchTile(
//             Icons.lock,
//             "App Lock / PIN",
//             appLockEnabled,
//             (val) => setState(() => appLockEnabled = val),
//           ),

//           const Divider(),

//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text("Sign Out", style: TextStyle(color: Colors.red)),
//             onTap: _logoutDialog,
//           ),

//           const SizedBox(height: 30),

//           const Center(
//             child: Column(
//               children: [
//                 Text("App Version 1.0.0"),
//                 SizedBox(height: 4),
//                 Text("Made with ❤️ in India"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _tile(
//     IconData icon,
//     String title,
//     String subtitle,
//     VoidCallback onTap,
//   ) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.green),
//       title: Text(title),
//       subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: onTap,
//     );
//   }

//   Widget _switchTile(
//     IconData icon,
//     String title,
//     bool value,
//     Function(bool) onChanged,
//   ) {
//     return SwitchListTile(
//       secondary: Icon(icon, color: Colors.green),
//       title: Text(title),
//       value: value,
//       onChanged: onChanged,
//     );
//   }

//   void _chooseLanguage() {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             title: const Text("English"),
//             onTap: () {
//               Provider.of<LanguageProvider>(
//                 context,
//                 listen: false,
//               ).changeLanguage('en');
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             title: const Text("हिन्दी"),
//             onTap: () {
//               Provider.of<LanguageProvider>(
//                 context,
//                 listen: false,
//               ).changeLanguage('hi');
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _changeNumber() {
//     showDialog(
//       context: context,
//       builder: (_) => const AlertDialog(
//         title: Text("Change Number"),
//         content: Text("OTP screen yaha ayegi (backend later)"),
//       ),
//     );
//   }

//   // void _restorePhotos() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (_) => AlertDialog(
//   //       title: const Text("Restore Photos"),
//   //       content: const Text("Restore backup photos?"),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context),
//   //           child: const Text("Cancel"),
//   //         ),
//   //         ElevatedButton(
//   //           onPressed: () => Navigator.pop(context),
//   //           child: const Text("Restore"),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   void _logoutDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Sign Out"),
//         content: const Text("Are you sure you want to logout?"),
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

// import 'package:flutter/material.dart';
// import '../../profile/screens/multi_device_screen.dart';
// import 'package:provider/provider.dart';
// import '../../../core/providers/language_provider.dart';
// import '../../../core/language/app_text.dart';
// import 'all_supplier_screen.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   bool backupEnabled = true;
//   bool appLockEnabled = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(AppText.of(context, 'settings'))),

//       body: ListView(
//         children: [
//           _tile(Icons.language, "Language", "English", _chooseLanguage),
//           _tile(Icons.phone, "Change Mobile Number", "", _changeNumber),

//           /// ⭐ NEW BUTTON
//           ListTile(
//             leading: const Icon(Icons.visibility_off, color: Colors.green),
//             title: const Text("Hide Suppliers"),
//             trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => HideSupplierScreen()),
//               );
//             },
//           ),

//           _switchTile(
//             Icons.lock,
//             "App Lock / PIN",
//             appLockEnabled,
//             (val) => setState(() => appLockEnabled = val),
//           ),

//           const Divider(),

//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text("Sign Out", style: TextStyle(color: Colors.red)),
//             onTap: _logoutDialog,
//           ),

//           const SizedBox(height: 30),

//           const Center(
//             child: Column(
//               children: [
//                 Text("App Version 1.0.0"),
//                 SizedBox(height: 4),
//                 Text("Made with ❤️ in India"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _tile(
//     IconData icon,
//     String title,
//     String subtitle,
//     VoidCallback onTap,
//   ) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.green),
//       title: Text(title),
//       subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: onTap,
//     );
//   }

//   Widget _switchTile(
//     IconData icon,
//     String title,
//     bool value,
//     Function(bool) onChanged,
//   ) {
//     return SwitchListTile(
//       secondary: Icon(icon, color: Colors.green),
//       title: Text(title),
//       value: value,
//       onChanged: onChanged,
//     );
//   }

//   void _chooseLanguage() {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             title: const Text("English"),
//             onTap: () {
//               Provider.of<LanguageProvider>(
//                 context,
//                 listen: false,
//               ).changeLanguage('en');
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             title: const Text("हिन्दी"),
//             onTap: () {
//               Provider.of<LanguageProvider>(
//                 context,
//                 listen: false,
//               ).changeLanguage('hi');
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _changeNumber() {
//     showDialog(
//       context: context,
//       builder: (_) => const AlertDialog(
//         title: Text("Change Number"),
//         content: Text("OTP screen yaha ayegi (backend later)"),
//       ),
//     );
//   }

//   void _logoutDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Sign Out"),
//         content: const Text("Are you sure you want to logout?"),
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
import '../../profile/screens/multi_device_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/language/app_text.dart';
import 'all_supplier_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool backupEnabled = true;
  bool appLockEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppText.of(context, 'settings'))),

      body: ListView(
        children: [
          _tile(Icons.language, "Language", "English", _chooseLanguage),

          _tile(Icons.phone, "Change Mobile Number", "", _changeNumber),

          /// ⭐ Hide Suppliers Button
          ListTile(
            leading: const Icon(Icons.visibility_off, color: Colors.green),
            title: const Text("Hide Suppliers"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AllSupplierScreen()),
              );
            },
          ),

          _switchTile(Icons.lock, "App Lock / PIN", appLockEnabled, (val) {
            setState(() {
              appLockEnabled = val;
            });
          }),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Sign Out", style: TextStyle(color: Colors.red)),
            onTap: _logoutDialog,
          ),

          const SizedBox(height: 30),

          const Center(
            child: Column(
              children: [
                Text("App Version 1.0.0"),
                SizedBox(height: 4),
                Text("Made with ❤️ in India"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _switchTile(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.green),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  void _chooseLanguage() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("English"),
              onTap: () {
                Provider.of<LanguageProvider>(
                  context,
                  listen: false,
                ).changeLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("हिन्दी"),
              onTap: () {
                Provider.of<LanguageProvider>(
                  context,
                  listen: false,
                ).changeLanguage('hi');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _changeNumber() {
    showDialog(
      context: context,
      builder: (_) {
        return const AlertDialog(
          title: Text("Change Number"),
          content: Text("OTP screen yaha ayegi (backend later)"),
        );
      },
    );
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
