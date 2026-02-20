import 'package:flutter/material.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/plan/screens/plan_screen.dart';
import 'more_sheet.dart';

class AppBottomNav extends StatefulWidget {
  const AppBottomNav({super.key});

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  int _index = 0;

  final _pages = const [DashboardScreen(), PlanScreen(), SizedBox()];

  void _onTap(int i) {
    if (i == 2) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => const MoreSheet(),
      );
      return;
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _onTap,
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Ledger'),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium),
            label: 'My Plan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.expand_less), label: 'More'),
        ],
      ),
    );
  }
}
