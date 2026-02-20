// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import '../widgets/app_bottom_nav.dart';

// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});

// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen> {
// //   @override
// //   void initState() {
// //     super.initState();

// //     /// 2 second loader
// //     Timer(const Duration(seconds: 2), () {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => const AppBottomNav()),
// //       );
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             /// APP NAME / LOGO
// //             const Icon(
// //               Icons.account_balance_wallet,
// //               size: 70,
// //               color: Colors.green,
// //             ),

// //             const SizedBox(height: 20),

// //             const Text(
// //               "OkCredit",
// //               style: TextStyle(
// //                 fontSize: 28,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.green,
// //               ),
// //             ),

// //             const SizedBox(height: 30),

// //             /// LOADER
// //             const CircularProgressIndicator(color: Colors.green),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    /// 2 sec baad home open
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppBottomNav()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          "assets/images/main-screen.jpeg",
          width: 520, // ⭐ full screen cover
        ),
      ),
    );
  }
}
