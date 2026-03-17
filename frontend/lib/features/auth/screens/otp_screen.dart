// import 'package:flutter/material.dart';
// import 'dart:async';
// import '../../../core/widgets/app_bottom_nav.dart';
// import 'package:hive/hive.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';

// class OTPScreen extends StatefulWidget {
//   final String phone;

//   const OTPScreen({super.key, required this.phone});

//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final List<TextEditingController> otpControllers = List.generate(
//     6,
//     (index) => TextEditingController(),
//   );
//   final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

//   // Timer variables
//   int _secondsRemaining = 120; // 2 minutes = 120 seconds
//   Timer? _timer;
//   bool _canResend = false;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     _canResend = false;
//     _secondsRemaining = 120;

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_secondsRemaining > 0) {
//           _secondsRemaining--;
//         } else {
//           _canResend = true;
//           _timer?.cancel();
//         }
//       });
//     });
//   }

//   String get timerText {
//     int minutes = _secondsRemaining ~/ 60;
//     int seconds = _secondsRemaining % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
//   }

//   void _resendOtp() {
//     if (_canResend) {
//       // Reset timer
//       _startTimer();

//       // Show feedback
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const Icon(Icons.check_circle, color: Colors.white),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   "OTP resent successfully to +91 ${widget.phone}",
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ),
//             ],
//           ),
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.green.shade600,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           duration: const Duration(seconds: 2),
//         ),
//       );

//       // Clear all OTP fields
//       for (var controller in otpControllers) {
//         controller.clear();
//       }
//       // Focus on first field
//       focusNodes[0].requestFocus();
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     for (var controller in otpControllers) {
//       controller.dispose();
//     }
//     for (var node in focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   void verifyOtp() {
//     String otp = otpControllers.map((c) => c.text).join();

//     if (otp.length == 6) {
//       FocusScope.of(context).unfocus();

//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const Center(child: CircularProgressIndicator()),
//       );

//       Future.delayed(const Duration(seconds: 1), () async {
//         final box = Hive.box('settings');
//         box.put('mobile', widget.phone);

//         /// ⭐ SERVER SE CUSTOMER LOAD
//         await Provider.of<CustomerProvider>(
//           context,
//           listen: false,
//         ).loadCustomers(widget.phone);

//         Navigator.pop(context);

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const AppBottomNav()),
//         );
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const Icon(Icons.error_outline, color: Colors.white),
//               const SizedBox(width: 12),
//               const Expanded(child: Text("Please enter complete 6-digit OTP")),
//             ],
//           ),
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.red.shade400,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//     }
//   }

//   void _onOtpChanged(int index, String value) {
//     setState(() {
//       if (value.length == 1 && index < 5) {
//         focusNodes[index + 1].requestFocus();
//       } else if (value.isEmpty && index > 0) {
//         focusNodes[index - 1].requestFocus();
//       }
//     });
//   }

//   Color _getTimerColor() {
//     if (_secondsRemaining > 60) {
//       return Colors.green.shade600;
//     } else if (_secondsRemaining > 30) {
//       return Colors.orange.shade600;
//     } else {
//       return Colors.red.shade600;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.arrow_back,
//               color: Colors.grey.shade700,
//               size: 20,
//             ),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Verify OTP",
//           style: TextStyle(
//             color: Colors.grey.shade800,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),

//               // Header Section
//               Center(
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Colors.blue.shade400,
//                             Colors.purple.shade400,
//                           ],
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.smartphone,
//                         size: 50,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     const Text(
//                       "Verification Code",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     RichText(
//                       textAlign: TextAlign.center,
//                       text: TextSpan(
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey.shade600,
//                           height: 1.5,
//                         ),
//                         children: [
//                           const TextSpan(
//                             text: "We've sent a 6-digit verification code to\n",
//                           ),
//                           TextSpan(
//                             text: "+91 ${widget.phone}",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 40),

//               // OTP Input Fields
//               Form(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(
//                     6,
//                     (index) => SizedBox(
//                       width: 50,
//                       height: 60,
//                       child: TextFormField(
//                         controller: otpControllers[index],
//                         focusNode: focusNodes[index],
//                         onChanged: (value) => _onOtpChanged(index, value),
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         maxLength: 1,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         decoration: InputDecoration(
//                           counterText: "",
//                           filled: true,
//                           fillColor: Colors.grey.shade50,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide.none,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide(
//                               color: Colors.grey.shade200,
//                               width: 1,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide(
//                               color: Colors.blue.shade400,
//                               width: 2,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // Timer and Resend Section
//               Center(
//                 child: Column(
//                   children: [
//                     // Animated Timer Container
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _getTimerColor().withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.timer, size: 20, color: _getTimerColor()),
//                           const SizedBox(width: 8),
//                           Text(
//                             "Code expires in ",
//                             style: TextStyle(
//                               color: Colors.grey.shade700,
//                               fontSize: 14,
//                             ),
//                           ),
//                           Text(
//                             timerText,
//                             style: TextStyle(
//                               color: _getTimerColor(),
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Resend Section
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Didn't receive code? ",
//                           style: TextStyle(color: Colors.grey.shade600),
//                         ),
//                         GestureDetector(
//                           onTap: _canResend ? _resendOtp : null,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _canResend
//                                   ? Colors.blue.shade50
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               "Resend OTP",
//                               style: TextStyle(
//                                 color: _canResend
//                                     ? Colors.blue.shade700
//                                     : Colors.grey.shade400,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     if (!_canResend)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: Text(
//                           "You can request new OTP after timer ends",
//                           style: TextStyle(
//                             color: Colors.grey.shade500,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),

//               const Spacer(),

//               // Verify Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: verifyOtp,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue.shade400,
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: const Text(
//                     "Verify & Continue",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Edit Number Option
//               Center(
//                 child: TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: TextButton.styleFrom(
//                     foregroundColor: Colors.grey.shade600,
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.edit, size: 18, color: Colors.grey.shade600),
//                       const SizedBox(width: 8),
//                       const Text("Edit Mobile Number"),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/widgets/app_bottom_nav.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import '../../../services/api_service.dart';
import 'package:uuid/uuid.dart';

class OTPScreen extends StatefulWidget {
  final String phone;

  const OTPScreen({super.key, required this.phone});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  int _secondsRemaining = 120;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 120;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  String get timerText {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  /// ✅ VERIFY OTP (MAIN FIX)
  void verifyOtp() async {
    String otp = otpControllers.map((c) => c.text).join();

    if (otp.length == 6) {
      FocusScope.of(context).unfocus();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final box = Hive.box('settings');

        /// ⭐ UNIQUE DEVICE ID (IMPORTANT)
        String deviceId = box.get("deviceId") ?? const Uuid().v4();
        await box.put("deviceId", deviceId);

        /// ⭐ DEVICE NAME
        String deviceName = "Android Device";

        /// ⭐ API CALL
        final res = await ApiService.verifyOtp(
          widget.phone,
          otp,
          deviceName,
          deviceId,
        );

        Navigator.pop(context);

        if (res["success"] == true) {
          box.put('mobile', widget.phone);

          await Provider.of<CustomerProvider>(
            context,
            listen: false,
          ).loadCustomers(widget.phone);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AppBottomNav()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res["message"] ?? "OTP failed")),
          );
        }
      } catch (e) {
        Navigator.pop(context);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Server error")));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter 6 digit OTP")));
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void _resendOtp() {
    if (_canResend) {
      _startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP resent to +91 ${widget.phone}")),
      );

      for (var c in otpControllers) {
        c.clear();
      }

      focusNodes[0].requestFocus();
    }
  }

  Color _getTimerColor() {
    if (_secondsRemaining > 60) return Colors.green;
    if (_secondsRemaining > 30) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var n in focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Text("OTP sent to +91 ${widget.phone}"),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 45,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    onChanged: (v) => _onOtpChanged(index, v),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: const InputDecoration(counterText: ""),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Expires in $timerText",
              style: TextStyle(color: _getTimerColor()),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: _canResend ? _resendOtp : null,
              child: const Text("Resend OTP"),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: verifyOtp,
                child: const Text("Verify & Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
