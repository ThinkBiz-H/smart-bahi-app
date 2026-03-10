// import 'package:flutter/material.dart';
// import 'edit_field_screen.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:hive/hive.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:io';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'dart:convert';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final settingsBox = Hive.box('settings');
//   File? logoFile;

//   String businessName = 'My Business';
//   String mobile = '+91 98765 43210';
//   String gst = 'Not Added';
//   String businessType = 'Retail';
//   String category = 'General Store';
//   String address = 'Add address';
//   String email = 'Add email';
//   String about = 'Add details';
//   String contactPerson = 'Owner';

//   /// ⭐ SHARE BUSINESS CARD (DYNAMIC)
//   void shareBusinessCard() {
//     final message =
//         '''
// 🏪 *$businessName*

// 👤 Contact: $contactPerson
// 📞 Phone: $mobile
// 📍 Address: $address
// 📧 Email: $email

// Manage your credit easily with SmartBahi App:
// https://play.google.com/store/apps/details?id=com.smartbahi.app
// ''';

//     Share.share(message);
//   }

//   @override
//   void initState() {
//     super.initState();

//     businessName = settingsBox.get('businessName', defaultValue: businessName);
//     mobile = settingsBox.get('mobile', defaultValue: mobile);
//     gst = settingsBox.get('gst', defaultValue: gst);
//     businessType = settingsBox.get('businessType', defaultValue: businessType);
//     category = settingsBox.get('category', defaultValue: category);
//     address = settingsBox.get('address', defaultValue: address);
//     email = settingsBox.get('email', defaultValue: email);
//     about = settingsBox.get('about', defaultValue: about);
//     contactPerson = settingsBox.get(
//       'contactPerson',
//       defaultValue: contactPerson,
//     );

//     final path = settingsBox.get('logo');
//     if (path != null && !kIsWeb) {
//       logoFile = File(path);
//     }
//   }

//   // Future<void> pickLogo() async {
//   //   final picker = ImagePicker();
//   //   final XFile? image = await picker.pickImage(
//   //     source: ImageSource.gallery,
//   //     imageQuality: 60,
//   //   );

//   //   if (image == null) return;

//   //   settingsBox.put('logo', image.path);

//   //   if (kIsWeb) {
//   //     setState(() {});
//   //   } else {
//   //     setState(() => logoFile = File(image.path));
//   //   }

//   //   /// ⭐ IMPORTANT — Dashboard ko update karega
//   //   final provider = context.read<CustomerProvider>();
//   //   provider.updateBusinessProfile(name: businessName, phone: mobile);
//   // }

//   Future<void> pickLogo() async {
//     final picker = ImagePicker();
//     final XFile? image = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 60,
//     );

//     if (image == null) return;

//     settingsBox.put('logo', image.path);

//     String? base64Image;

//     if (kIsWeb) {
//       final bytes = await image.readAsBytes();
//       base64Image = base64Encode(bytes);
//       setState(() {});
//     } else {
//       final file = File(image.path);
//       final bytes = await file.readAsBytes();
//       base64Image = base64Encode(bytes);
//       setState(() => logoFile = file);
//     }

//     /// ⭐⭐⭐ DASHBOARD UPDATE (MOST IMPORTANT) ⭐⭐⭐
//     final provider = context.read<CustomerProvider>();

//     provider.updateBusinessProfile(
//       name: businessName,
//       phone: mobile,
//       base64Image: base64Image,
//     );
//   }

//   Future<void> _editField(
//     String key,
//     String title,
//     String currentValue,
//     Function(String) onSave,
//   ) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) =>
//             EditFieldScreen(title: title, initialValue: currentValue),
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         onSave(result);
//         settingsBox.put(key, result);
//       });

//       /// ⭐⭐ UPDATE PROVIDER LIVE ⭐⭐
//       final provider = context.read<CustomerProvider>();

//       provider.updateBusinessProfile(name: businessName, phone: mobile);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final logoPath = settingsBox.get('logo');

//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile')),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           /// LOGO + NAME
//           Center(
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: pickLogo,
//                   child: CircleAvatar(
//                     radius: 44,
//                     backgroundColor: Colors.green.shade100,
//                     backgroundImage: logoFile != null
//                         ? FileImage(logoFile!)
//                         : (logoPath != null && kIsWeb)
//                         ? NetworkImage(logoPath)
//                         : null,
//                     child: logoFile == null && logoPath == null
//                         ? const Icon(Icons.store, size: 40, color: Colors.green)
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   businessName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Text(mobile, style: const TextStyle(color: Colors.grey)),

//                 /// ⭐ SHARE BUTTON
//                 const SizedBox(height: 12),
//                 ElevatedButton.icon(
//                   onPressed: shareBusinessCard,
//                   icon: const Icon(Icons.share),
//                   label: const Text("Share Business Card"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0C2752),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 24),

//           const _SectionTitle('Business Information'),
//           _tile(
//             Icons.store,
//             'Business Name',
//             businessName,
//             () => _editField(
//               'businessName',
//               'Business Name',
//               businessName,
//               (v) => businessName = v,
//             ),
//           ),
//           _tile(
//             Icons.phone,
//             'Mobile Number',
//             mobile,
//             () => _editField(
//               'mobile',
//               'Mobile Number',
//               mobile,
//               (v) => mobile = v,
//             ),
//           ),
//           _tile(
//             Icons.receipt,
//             'GST Number',
//             gst,
//             () => _editField('gst', 'GST Number', gst, (v) => gst = v),
//           ),
//           _tile(
//             Icons.business,
//             'Business Type',
//             businessType,
//             () => _editField(
//               'businessType',
//               'Business Type',
//               businessType,
//               (v) => businessType = v,
//             ),
//           ),
//           _tile(
//             Icons.category,
//             'Category',
//             category,
//             () => _editField(
//               'category',
//               'Category',
//               category,
//               (v) => category = v,
//             ),
//           ),
//           _tile(
//             Icons.location_on,
//             'Address',
//             address,
//             () => _editField('address', 'Address', address, (v) => address = v),
//           ),

//           const _SectionTitle('Other Information'),
//           _tile(
//             Icons.email,
//             'Email',
//             email,
//             () => _editField('email', 'Email', email, (v) => email = v),
//           ),
//           _tile(
//             Icons.info,
//             'About Business',
//             about,
//             () =>
//                 _editField('about', 'About Business', about, (v) => about = v),
//           ),
//           _tile(
//             Icons.person,
//             'Contact Person',
//             contactPerson,
//             () => _editField(
//               'contactPerson',
//               'Contact Person',
//               contactPerson,
//               (v) => contactPerson = v,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _tile(IconData icon, String title, String value, VoidCallback onTap) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.green),
//         title: Text(title),
//         subtitle: Text(value),
//         trailing: const Icon(Icons.chevron_right),
//         onTap: onTap,
//       ),
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String title;
//   const _SectionTitle(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8, top: 12),
//       child: Text(
//         title,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
/// tyr code tha
// ///
// import 'package:flutter/material.dart';
// import 'edit_field_screen.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:hive/hive.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:io';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'dart:convert';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final settingsBox = Hive.box('settings');
//   File? logoFile;

//   String businessName = 'My Business';
//   String mobile = '+91 98765 43210';
//   String gst = 'Not Added';
//   String businessType = 'Retail';
//   String category = 'General Store';
//   String address = 'Add address';
//   String email = 'Add email';
//   String about = 'Add details';
//   String contactPerson = 'Owner';

//   /// ⭐ SHARE BUSINESS CARD (DYNAMIC)
//   void shareBusinessCard() {
//     final message =
//         '''
// 🏪 *$businessName*

// 👤 Contact: $contactPerson
// 📞 Phone: $mobile
// 📍 Address: $address
// 📧 Email: $email

// Manage your credit easily with SmartBahi App:
// https://play.google.com/store/apps/details?id=com.smartbahi.app
// ''';

//     Share.share(message);
//   }

//   Future<void> loadProfile() async {
//     try {
//       final res = await ApiService.getProfile(mobile);

//       setState(() {
//         businessName = res["businessName"] ?? businessName;
//         mobile = res["mobile"] ?? mobile;
//         gst = res["gst"] ?? gst;
//         businessType = res["businessType"] ?? businessType;
//         category = res["category"] ?? category;
//         address = res["address"] ?? address;
//         email = res["email"] ?? email;
//         about = res["about"] ?? about;
//         contactPerson = res["contactPerson"] ?? contactPerson;
//       });
//     } catch (e) {
//       debugPrint("Profile load error: $e");
//     }
//   }
//   Future<void> saveProfile() async {
//   try {
//     await ApiService.updateProfile({
//       "mobile": mobile,
//       "businessName": businessName,
//       "gst": gst,
//       "businessType": businessType,
//       "category": category,
//       "address": address,
//       "email": email,
//       "about": about,
//       "contactPerson": contactPerson
//     });
//   } catch (e) {
//     debugPrint("Profile save error: $e");
//   }
// }

//   @override
//   void initState() {
//     super.initState();

//     businessName = settingsBox.get('businessName', defaultValue: businessName);
//     mobile = settingsBox.get('mobile', defaultValue: mobile);
//     gst = settingsBox.get('gst', defaultValue: gst);
//     businessType = settingsBox.get('businessType', defaultValue: businessType);
//     category = settingsBox.get('category', defaultValue: category);
//     address = settingsBox.get('address', defaultValue: address);
//     email = settingsBox.get('email', defaultValue: email);
//     about = settingsBox.get('about', defaultValue: about);
//     contactPerson = settingsBox.get(
//       'contactPerson',
//       defaultValue: contactPerson,
//     );

//     final path = settingsBox.get('logo');
//     if (path != null && !kIsWeb) {
//       logoFile = File(path);
//     }
//   }

//   Future<void> pickLogo() async {
//     final picker = ImagePicker();
//     final XFile? image = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 60,
//     );

//     if (image == null) return;

//     settingsBox.put('logo', image.path);

//     String? base64Image;

//     if (kIsWeb) {
//       final bytes = await image.readAsBytes();
//       base64Image = base64Encode(bytes);
//       setState(() {});
//     } else {
//       final file = File(image.path);
//       final bytes = await file.readAsBytes();
//       base64Image = base64Encode(bytes);
//       setState(() => logoFile = file);
//     }

//     /// ⭐⭐⭐ DASHBOARD UPDATE (MOST IMPORTANT) ⭐⭐⭐
//     final provider = context.read<CustomerProvider>();

//     provider.updateBusinessProfile(
//       name: businessName,
//       phone: mobile,
//       base64Image: base64Image,
//     );
//   }

//   Future<void> _editField(
//     String key,
//     String title,
//     String currentValue,
//     Function(String) onSave,
//   ) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) =>
//             EditFieldScreen(title: title, initialValue: currentValue),
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         onSave(result);
//         settingsBox.put(key, result);
//       });

//       /// ⭐⭐ UPDATE PROVIDER LIVE ⭐⭐
//       final provider = context.read<CustomerProvider>();

//       provider.updateBusinessProfile(name: businessName, phone: mobile);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final logoPath = settingsBox.get('logo');

//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile')),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           /// LOGO + NAME
//           Center(
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: pickLogo,
//                   child: CircleAvatar(
//                     radius: 44,
//                     backgroundColor: Colors.green.shade100,
//                     backgroundImage: logoFile != null
//                         ? FileImage(logoFile!)
//                         : (logoPath != null && kIsWeb)
//                         ? NetworkImage(logoPath)
//                         : null,
//                     child: logoFile == null && logoPath == null
//                         ? const Icon(Icons.store, size: 40, color: Colors.green)
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   businessName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Text(mobile, style: const TextStyle(color: Colors.grey)),

//                 /// ⭐ SHARE BUTTON
//                 const SizedBox(height: 12),
//                 ElevatedButton.icon(
//                   onPressed: shareBusinessCard,
//                   icon: const Icon(Icons.share),
//                   label: const Text("Share Business Card"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0C2752),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 24),

//           const _SectionTitle('Business Information'),
//           _tile(
//             Icons.store,
//             'Business Name',
//             businessName,
//             () => _editField(
//               'businessName',
//               'Business Name',
//               businessName,
//               (v) => businessName = v,
//             ),
//           ),
//           _tile(
//             Icons.phone,
//             'Mobile Number',
//             mobile,
//             () => _editField(
//               'mobile',
//               'Mobile Number',
//               mobile,
//               (v) => mobile = v,
//             ),
//           ),
//           _tile(
//             Icons.receipt,
//             'GST Number',
//             gst,
//             () => _editField('gst', 'GST Number', gst, (v) => gst = v),
//           ),
//           _tile(
//             Icons.business,
//             'Business Type',
//             businessType,
//             () => _editField(
//               'businessType',
//               'Business Type',
//               businessType,
//               (v) => businessType = v,
//             ),
//           ),
//           _tile(
//             Icons.category,
//             'Category',
//             category,
//             () => _editField(
//               'category',
//               'Category',
//               category,
//               (v) => category = v,
//             ),
//           ),
//           _tile(
//             Icons.location_on,
//             'Address',
//             address,
//             () => _editField('address', 'Address', address, (v) => address = v),
//           ),

//           const _SectionTitle('Other Information'),
//           _tile(
//             Icons.email,
//             'Email',
//             email,
//             () => _editField('email', 'Email', email, (v) => email = v),
//           ),
//           _tile(
//             Icons.info,
//             'About Business',
//             about,
//             () =>
//                 _editField('about', 'About Business', about, (v) => about = v),
//           ),
//           _tile(
//             Icons.person,
//             'Contact Person',
//             contactPerson,
//             () => _editField(
//               'contactPerson',
//               'Contact Person',
//               contactPerson,
//               (v) => contactPerson = v,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _tile(IconData icon, String title, String value, VoidCallback onTap) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.green),
//         title: Text(title),
//         subtitle: Text(value),
//         trailing: const Icon(Icons.chevron_right),
//         onTap: onTap,
//       ),
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String title;
//   const _SectionTitle(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8, top: 12),
//       child: Text(
//         title,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

/////backend connect

import 'package:flutter/material.dart';
import 'edit_field_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'dart:convert';
import 'package:frontend/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final settingsBox = Hive.box('settings');
  File? logoFile;

  String businessName = 'My Business';
  String mobile = '+91 98765 43210';
  String gst = 'Not Added';
  String businessType = 'Retail';
  String category = 'General Store';
  String address = 'Add address';
  String email = 'Add email';
  String about = 'Add details';
  String contactPerson = 'Owner';

  /// ⭐ SHARE BUSINESS CARD
  void shareBusinessCard() {
    final message =
        '''
🏪 *$businessName*

👤 Contact: $contactPerson
📞 Phone: $mobile
📍 Address: $address
📧 Email: $email

Manage your credit easily with SmartBahi App:
https://play.google.com/store/apps/details?id=com.smartbahi.app
''';

    Share.share(message);
  }

  /// ⭐ LOAD PROFILE FROM BACKEND
  Future<void> loadProfile() async {
    try {
      final cleanMobile = mobile.replaceAll(RegExp(r'\D'), '');

      final res = await ApiService.getProfile(cleanMobile);

      if (res == null) return;

      setState(() {
        businessName = res["businessName"]?.toString() ?? businessName;
        gst = res["gst"]?.toString() ?? gst;
        businessType = res["businessType"]?.toString() ?? businessType;
        category = res["category"]?.toString() ?? category;
        address = res["address"]?.toString() ?? address;
        email = res["email"]?.toString() ?? email;
        about = res["about"]?.toString() ?? about;
        contactPerson = res["contactPerson"]?.toString() ?? contactPerson;
      });
    } catch (e) {
      debugPrint("Profile load error: $e");
    }
  }

  /// ⭐ SAVE PROFILE TO BACKEND
  Future<void> saveProfile() async {
    try {
      final cleanMobile = mobile.replaceAll(RegExp(r'\D'), '');

      await ApiService.updateProfile({
        "mobile": cleanMobile,
        "businessName": businessName,
        "gst": gst,
        "businessType": businessType,
        "category": category,
        "address": address,
        "email": email,
        "about": about,
        "contactPerson": contactPerson,
      });
    } catch (e) {
      debugPrint("Profile save error: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    businessName = settingsBox.get('businessName', defaultValue: businessName);
    mobile = settingsBox.get('mobile', defaultValue: mobile);
    gst = settingsBox.get('gst', defaultValue: gst);
    businessType = settingsBox.get('businessType', defaultValue: businessType);
    category = settingsBox.get('category', defaultValue: category);
    address = settingsBox.get('address', defaultValue: address);
    email = settingsBox.get('email', defaultValue: email);
    about = settingsBox.get('about', defaultValue: about);
    contactPerson = settingsBox.get(
      'contactPerson',
      defaultValue: contactPerson,
    );

    final path = settingsBox.get('logo');
    if (path != null && !kIsWeb) {
      logoFile = File(path);
    }

    /// ⭐ backend profile load
    Future.microtask(() => loadProfile());
  }

  Future<void> pickLogo() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );

    if (image == null) return;

    settingsBox.put('logo', image.path);

    String? base64Image;

    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      base64Image = base64Encode(bytes);
      setState(() {});
    } else {
      final file = File(image.path);
      final bytes = await file.readAsBytes();
      base64Image = base64Encode(bytes);
      setState(() => logoFile = file);
    }

    final provider = context.read<CustomerProvider>();

    provider.updateBusinessProfile(
      name: businessName,
      phone: mobile,
      base64Image: base64Image,
    );
  }

  Future<void> _editField(
    String key,
    String title,
    String currentValue,
    Function(String) onSave,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditFieldScreen(title: title, initialValue: currentValue),
      ),
    );

    if (result != null) {
      setState(() {
        onSave(result);
        settingsBox.put(key, result);
      });

      final provider = context.read<CustomerProvider>();

      provider.updateBusinessProfile(name: businessName, phone: mobile);

      /// ⭐ SAVE TO BACKEND
      await saveProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoPath = settingsBox.get('logo');

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickLogo,
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.green.shade100,
                    backgroundImage: logoFile != null
                        ? FileImage(logoFile!)
                        : (logoPath != null && kIsWeb)
                        ? NetworkImage(logoPath)
                        : null,
                    child: logoFile == null && logoPath == null
                        ? const Icon(Icons.store, size: 40, color: Colors.green)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  businessName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(mobile, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: shareBusinessCard,
                  icon: const Icon(Icons.share),
                  label: const Text("Share Business Card"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C2752),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const _SectionTitle('Business Information'),

          _tile(
            Icons.store,
            'Business Name',
            businessName,
            () => _editField(
              'businessName',
              'Business Name',
              businessName,
              (v) => businessName = v,
            ),
          ),

          _tile(
            Icons.phone,
            'Mobile Number',
            mobile,
            () => _editField(
              'mobile',
              'Mobile Number',
              mobile,
              (v) => mobile = v,
            ),
          ),

          _tile(
            Icons.receipt,
            'GST Number',
            gst,
            () => _editField('gst', 'GST Number', gst, (v) => gst = v),
          ),

          _tile(
            Icons.business,
            'Business Type',
            businessType,
            () => _editField(
              'businessType',
              'Business Type',
              businessType,
              (v) => businessType = v,
            ),
          ),

          _tile(
            Icons.category,
            'Category',
            category,
            () => _editField(
              'category',
              'Category',
              category,
              (v) => category = v,
            ),
          ),

          _tile(
            Icons.location_on,
            'Address',
            address,
            () => _editField('address', 'Address', address, (v) => address = v),
          ),

          const _SectionTitle('Other Information'),

          _tile(
            Icons.email,
            'Email',
            email,
            () => _editField('email', 'Email', email, (v) => email = v),
          ),

          _tile(
            Icons.info,
            'About Business',
            about,
            () =>
                _editField('about', 'About Business', about, (v) => about = v),
          ),

          _tile(
            Icons.person,
            'Contact Person',
            contactPerson,
            () => _editField(
              'contactPerson',
              'Contact Person',
              contactPerson,
              (v) => contactPerson = v,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String value, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
