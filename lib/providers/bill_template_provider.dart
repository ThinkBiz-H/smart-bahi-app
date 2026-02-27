import 'package:flutter/material.dart';

enum BillTemplate { normal, prime }

class BillTemplateProvider extends ChangeNotifier {
  BillTemplate _selectedTemplate = BillTemplate.normal;

  BillTemplate get selectedTemplate => _selectedTemplate;

  bool get isPrime => _selectedTemplate == BillTemplate.prime;

  void setTemplate(BillTemplate template) {
    _selectedTemplate = template;
    notifyListeners();
  }
}
