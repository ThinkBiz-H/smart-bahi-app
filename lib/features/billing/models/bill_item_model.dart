class BillItem {
  String name;
  int qty;
  double price;

  BillItem({required this.name, required this.qty, required this.price});

  double get total => qty * price;
}
