
import 'bill_item_model.dart';

class BillModel {
  String id; // ⭐ unique id for edit/update
  String billNo;
  DateTime date;
  String customerName;
  List<BillItem> items;
  double discount;
  double extraCharges;
  bool isPaid; // ⭐ VERY IMPORTANT

  BillModel({
    required this.id,
    required this.billNo,
    required this.date,
    required this.customerName,
    required this.items,
    this.discount = 0,
    this.extraCharges = 0,
    this.isPaid = false,
  });

  double get subTotal => items.fold(0, (sum, item) => sum + item.total);

  double get grandTotal => subTotal - discount + extraCharges;
}
