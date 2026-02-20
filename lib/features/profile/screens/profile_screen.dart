
import 'package:flutter/material.dart';
import 'edit_field_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'dart:io';

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

  /// ⭐ LOAD DATA FROM HIVE
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
  }

  /// 📷 PICK LOGO + SAVE
  Future<void> pickLogo() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );

    if (image == null) return;

    settingsBox.put('logo', image.path);

    if (kIsWeb) {
      setState(() {});
    } else {
      setState(() => logoFile = File(image.path));
    }
  }

  /// ✏️ EDIT FIELD + SAVE IN HIVE
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
        settingsBox.put(key, result); // ⭐ SAVE PERMANENTLY
      });
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
          /// LOGO + NAME
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
