// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';

// import 'providers/customer_provider.dart';
// import 'core/widgets/app_bottom_nav.dart';
// import 'core/providers/language_provider.dart';

// // ⭐ STOCK MODEL
// import 'features/stock/models/stock_item.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   /// ⭐ INIT HIVE
//   await Hive.initFlutter();

//   /// ⭐ REGISTER ALL ADAPTERS (Future me aur bhi aayenge)
//   Hive.registerAdapter(StockItemAdapter());

//   /// ⭐ OPEN ALL BOXES (APP START ME HI OPEN KARTE HAIN)
//   // await Future.wait([Hive.openBox('bills'), Hive.openBox<StockItem>('stock')]);
//   await Future.wait([
//     Hive.openBox('bills'),
//     Hive.openBox<StockItem>('stock'),
//     Hive.openBox('settings'), // ⭐ NEW BOX (USER PROFILE)
//   ]);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => CustomerProvider()),
//         ChangeNotifierProvider(create: (_) => LanguageProvider()),
//       ],
//       child: Consumer<LanguageProvider>(
//         builder: (context, langProvider, _) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,

//             /// 🌍 LANGUAGE LISTENER
//             locale: langProvider.locale,

//             /// 🎨 GLOBAL THEME (Vyapar style green)
//             theme: ThemeData(
//               primarySwatch: Colors.green,
//               scaffoldBackgroundColor: const Color(0xfff6f6f6),
//               appBarTheme: const AppBarTheme(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 elevation: 0,
//                 centerTitle: false,
//               ),
//               elevatedButtonTheme: ElevatedButtonThemeData(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//               ),
//             ),

//             home: const AppBottomNav(),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'features/customer/screens/customer_list_screen.dart';
import 'providers/customer_provider.dart';
// import 'core/widgets/app_bottom_nav.dart';
import 'core/providers/language_provider.dart';
import 'core/screens/splash_screen.dart';
// ⭐ NEW IMPORTS (STATEMENT SCREENS)

import 'features/supplier/screens/supplier_statement_screen.dart';

// ⭐ STOCK MODEL
import 'features/stock/models/stock_item.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ⭐ INIT HIVE
  await Hive.initFlutter();

  /// ⭐ REGISTER ADAPTERS
  Hive.registerAdapter(StockItemAdapter());

  /// ⭐ OPEN BOXES
  await Future.wait([
    Hive.openBox('bills'),
    Hive.openBox<StockItem>('stock'),
    Hive.openBox('settings'),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, langProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            /// 🌍 LANGUAGE
            locale: langProvider.locale,

            /// 🎨 THEME
            theme: ThemeData(
              primarySwatch: Colors.green,
              scaffoldBackgroundColor: const Color(0xfff6f6f6),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                centerTitle: false,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            /// ⭐ ROUTES ADDED HERE
            routes: {
              "/supplierStatement": (_) => const SupplierStatementScreen(),
              "/customerList": (_) => const CustomerListScreen(),
            },
            home: const SplashScreen(),
            // home: const AppBottomNav(),
          );
        },
      ),
    );
  }
}
