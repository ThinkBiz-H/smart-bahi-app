import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/widgets/app_bottom_nav.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';

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

  // Timer variables
  int _secondsRemaining = 120; // 2 minutes = 120 seconds
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

  void _resendOtp() {
    if (_canResend) {
      // Reset timer
      _startTimer();

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "OTP resent successfully to +91 ${widget.phone}",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Clear all OTP fields
      for (var controller in otpControllers) {
        controller.clear();
      }
      // Focus on first field
      focusNodes[0].requestFocus();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void verifyOtp() {
    String otp = otpControllers.map((c) => c.text).join();

    if (otp.length == 6) {
      FocusScope.of(context).unfocus();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      Future.delayed(const Duration(seconds: 1), () async {
        final box = Hive.box('settings');
        box.put('mobile', widget.phone);

        /// ⭐ SERVER SE CUSTOMER LOAD
        await Provider.of<CustomerProvider>(
          context,
          listen: false,
        ).loadCustomers(widget.phone);

        Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AppBottomNav()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(child: Text("Please enter complete 6-digit OTP")),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _onOtpChanged(int index, String value) {
    setState(() {
      if (value.length == 1 && index < 5) {
        focusNodes[index + 1].requestFocus();
      } else if (value.isEmpty && index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    });
  }

  Color _getTimerColor() {
    if (_secondsRemaining > 60) {
      return Colors.green.shade600;
    } else if (_secondsRemaining > 30) {
      return Colors.orange.shade600;
    } else {
      return Colors.red.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.grey.shade700,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Verify OTP",
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header Section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade400,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.smartphone,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Verification Code",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text: "We've sent a 6-digit verification code to\n",
                          ),
                          TextSpan(
                            text: "+91 ${widget.phone}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // OTP Input Fields
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 50,
                      height: 60,
                      child: TextFormField(
                        controller: otpControllers[index],
                        focusNode: focusNodes[index],
                        onChanged: (value) => _onOtpChanged(index, value),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.blue.shade400,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Timer and Resend Section
              Center(
                child: Column(
                  children: [
                    // Animated Timer Container
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _getTimerColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer, size: 20, color: _getTimerColor()),
                          const SizedBox(width: 8),
                          Text(
                            "Code expires in ",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            timerText,
                            style: TextStyle(
                              color: _getTimerColor(),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Resend Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code? ",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        GestureDetector(
                          onTap: _canResend ? _resendOtp : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _canResend
                                  ? Colors.blue.shade50
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                color: _canResend
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (!_canResend)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "You can request new OTP after timer ends",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const Spacer(),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Verify & Continue",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Edit Number Option
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      const Text("Edit Mobile Number"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

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

// import 'package:flutter/material.dart';
// import 'dart:async';
// import '../../../core/widgets/app_bottom_nav.dart';
// import 'package:hive/hive.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import '../../../services/api_service.dart';
// import 'package:device_info_plus/device_info_plus.dart';

// class OTPScreen extends StatefulWidget {
//   final String phone;

//   const OTPScreen({super.key, required this.phone});

//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final List<TextEditingController> otpControllers =
//       List.generate(6, (index) => TextEditingController());
//   final List<FocusNode> focusNodes =
//       List.generate(6, (index) => FocusNode());

//   int _secondsRemaining = 120;
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

//   /// DEVICE NAME
//   Future<String> getDeviceName() async {
//     final deviceInfo = DeviceInfoPlugin();

//     try {
//       final webInfo = await deviceInfo.webBrowserInfo;
//       return webInfo.userAgent ?? "Web Browser";
//     } catch (e) {
//       return "Unknown Device";
//     }
//   }

//   /// VERIFY OTP
//   void verifyOtp() async {
//     String otp = otpControllers.map((c) => c.text).join();

//     if (otp.length == 6) {
//       FocusScope.of(context).unfocus();

//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) =>
//             const Center(child: CircularProgressIndicator()),
//       );

//       try {
//         final deviceName = await getDeviceName();
//         final deviceId = widget.phone + deviceName;

//         final res = await ApiService.verifyOtp(
//           widget.phone,
//           otp,
//           deviceName,
//           deviceId,
//         );

//         Navigator.pop(context);

//         if (res["success"] == true) {
//           final box = Hive.box('settings');
//           box.put('mobile', widget.phone);

//           await Provider.of<CustomerProvider>(
//             context,
//             listen: false,
//           ).loadCustomers(widget.phone);

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => const AppBottomNav()),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(res["message"] ?? "OTP failed"),
//             ),
//           );
//         }
//       } catch (e) {
//         Navigator.pop(context);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Server error")),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: const [
//               Icon(Icons.error_outline, color: Colors.white),
//               SizedBox(width: 12),
//               Expanded(
//                 child:
//                     Text("Please enter complete 6-digit OTP"),
//               ),
//             ],
//           ),
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _resendOtp() {
//     if (_canResend) {
//       _startTimer();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               "OTP resent successfully to +91 ${widget.phone}"),
//         ),
//       );

//       for (var controller in otpControllers) {
//         controller.clear();
//       }

//       focusNodes[0].requestFocus();
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
//           padding:
//               const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),

//               /// HEADER
//               Center(
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
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
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       "OTP sent to +91 ${widget.phone}",
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 40),

//               /// OTP BOXES
//               Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.spaceEvenly,
//                 children: List.generate(
//                   6,
//                   (index) => SizedBox(
//                     width: 50,
//                     height: 60,
//                     child: TextFormField(
//                       controller: otpControllers[index],
//                       focusNode: focusNodes[index],
//                       onChanged: (value) =>
//                           _onOtpChanged(index, value),
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       maxLength: 1,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       decoration: InputDecoration(
//                         counterText: "",
//                         filled: true,
//                         fillColor: Colors.grey.shade50,
//                         border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.circular(16),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               /// TIMER
//               Center(
//                 child: Text(
//                   "OTP expires in $timerText",
//                   style:
//                       TextStyle(color: _getTimerColor()),
//                 ),
//               ),

//               const Spacer(),

//               /// VERIFY BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: verifyOtp,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         Colors.blue.shade400,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: const Text(
//                     "Verify & Continue",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600),
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
// // }
// import 'package:flutter/material.dart';
// import 'dart:async';
// import '../../../core/widgets/app_bottom_nav.dart';
// import 'package:hive/hive.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import '../../../services/api_service.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:pinput/pinput.dart'; // Add this to pubspec.yaml

// class OTPScreen extends StatefulWidget {
//   final String phone;

//   const OTPScreen({super.key, required this.phone});

//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> with TickerProviderStateMixin {
//   late final TextEditingController _pinController = TextEditingController();
//   final FocusNode _pinFocusNode = FocusNode();

//   int _secondsRemaining = 120;
//   Timer? _timer;
//   bool _canResend = false;
//   bool _isVerifying = false;

//   late final AnimationController _shakeController;
//   late final Animation<double> _shakeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();

//     _shakeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
//       CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
//     );
//   }

//   void _startTimer() {
//     _canResend = false;
//     _secondsRemaining = 120;

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           if (_secondsRemaining > 0) {
//             _secondsRemaining--;
//           } else {
//             _canResend = true;
//             _timer?.cancel();
//           }
//         });
//       }
//     });
//   }

//   String get timerText {
//     int minutes = _secondsRemaining ~/ 60;
//     int seconds = _secondsRemaining % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
//   }

//   Future<String> getDeviceName() async {
//     final deviceInfo = DeviceInfoPlugin();
//     try {
//       final webInfo = await deviceInfo.webBrowserInfo;
//       return webInfo.userAgent ?? "Web Browser";
//     } catch (e) {
//       return "Unknown Device";
//     }
//   }

//   void verifyOtp() async {
//     String otp = _pinController.text.trim();

//     if (otp.length != 6) {
//       _shakeController.forward().then((_) => _shakeController.reverse());

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("Please enter complete 6-digit OTP"),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           backgroundColor: Colors.red.shade400,
//         ),
//       );
//       return;
//     }

//     FocusScope.of(context).unfocus();

//     setState(() => _isVerifying = true);

//     try {
//       final deviceName = await getDeviceName();
//       final deviceId = widget.phone + deviceName;

//       final res = await ApiService.verifyOtp(
//         widget.phone,
//         otp,
//         deviceName,
//         deviceId,
//       );

//       if (!mounted) return;

//       if (res["success"] == true) {
//         final box = Hive.box('settings');
//         await box.put('mobile', widget.phone);
//         await box.put('isLoggedIn', true);

//         await Provider.of<CustomerProvider>(
//           context,
//           listen: false,
//         ).loadCustomers(widget.phone);

//         if (!mounted) return;

//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (context, animation, secondaryAnimation) =>
//                 const AppBottomNav(),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//                   const begin = Offset(1.0, 0.0);
//                   const end = Offset.zero;
//                   const curve = Curves.easeInOut;
//                   var tween = Tween(
//                     begin: begin,
//                     end: end,
//                   ).chain(CurveTween(curve: curve));
//                   return SlideTransition(
//                     position: animation.drive(tween),
//                     child: child,
//                   );
//                 },
//           ),
//         );
//       } else {
//         _shakeController.forward().then((_) => _shakeController.reverse());

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(res["message"] ?? "Invalid OTP. Please try again."),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             backgroundColor: Colors.red.shade400,
//           ),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("Network error. Please check your connection."),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           backgroundColor: Colors.red.shade400,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isVerifying = false);
//       }
//     }
//   }

//   void _resendOtp() async {
//     if (_canResend) {
//       setState(() {
//         _pinController.clear();
//         _startTimer();
//       });

//       try {
//         // Call your resend OTP API here
//         // await ApiService.resendOtp(widget.phone);

//         if (!mounted) return;

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("OTP resent successfully to +91 ${widget.phone}"),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             backgroundColor: Colors.green.shade400,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       } catch (e) {
//         if (!mounted) return;

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text("Failed to resend OTP. Please try again."),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             backgroundColor: Colors.red.shade400,
//           ),
//         );
//       }
//     }
//   }

//   Color _getTimerColor() {
//     if (_secondsRemaining > 60) return Colors.green;
//     if (_secondsRemaining > 30) return Colors.orange;
//     return Colors.red;
//   }

//   String _getTimerMessage() {
//     if (_secondsRemaining > 0) {
//       return "OTP expires in $timerText";
//     } else {
//       return "OTP expired";
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pinController.dispose();
//     _pinFocusNode.dispose();
//     _shakeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: const TextStyle(
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//         color: Colors.black,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade300),
//         color: Colors.white,
//       ),
//     );

//     final focusedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration!.copyWith(
//         border: Border.all(color: Colors.blue, width: 2),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration!.copyWith(
//         border: Border.all(color: Colors.green),
//         color: Colors.green.shade50,
//       ),
//     );

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
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(Icons.arrow_back, color: Colors.black87),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Verify OTP",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey.shade800,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),

//                 // Animated Illustration
//                 TweenAnimationBuilder(
//                   tween: Tween<double>(begin: 0, end: 1),
//                   duration: const Duration(milliseconds: 800),
//                   curve: Curves.easeOutBack,
//                   builder: (context, double value, child) {
//                     return Transform.scale(
//                       scale: value,
//                       child: Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade50,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.smartphone_outlined,
//                           size: 60,
//                           color: Colors.blue.shade700,
//                         ),
//                       ),
//                     );
//                   },
//                 ),

//                 const SizedBox(height: 30),

//                 // Title
//                 Text(
//                   "Enter Verification Code",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey.shade800,
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 // Subtitle
//                 RichText(
//                   text: TextSpan(
//                     style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
//                     children: [
//                       const TextSpan(text: "We've sent a 6-digit code to "),
//                       TextSpan(
//                         text: "+91 ${widget.phone}",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),

//                 const SizedBox(height: 40),

//                 // OTP Input using Pinput for better UX
//                 AnimatedBuilder(
//                   animation: _shakeAnimation,
//                   builder: (context, child) {
//                     return Transform.translate(
//                       offset: Offset(_shakeAnimation.value, 0),
//                       child: child,
//                     );
//                   },
//                   child: Pinput(
//                     controller: _pinController,
//                     focusNode: _pinFocusNode,
//                     length: 6,
//                     defaultPinTheme: defaultPinTheme,
//                     focusedPinTheme: focusedPinTheme,
//                     submittedPinTheme: submittedPinTheme,
//                     onCompleted: (pin) => verifyOtp(),
//                     keyboardType: TextInputType.number,
//                     autofocus: true,
//                     androidSmsAutofillMethod:
//                         AndroidSmsAutofillMethod.smsUserConsent,
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 // Timer with progress indicator
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                   decoration: BoxDecoration(
//                     color: _getTimerColor().withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.timer_outlined,
//                         size: 20,
//                         color: _getTimerColor(),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         _getTimerMessage(),
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: _getTimerColor(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // Resend option
//                 if (_canResend) ...[
//                   Text(
//                     "Didn't receive the code?",
//                     style: TextStyle(color: Colors.grey.shade600),
//                   ),
//                   const SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: _resendOtp,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.blue.shade50,
//                       ),
//                       child: Text(
//                         "Resend OTP",
//                         style: TextStyle(
//                           color: Colors.blue.shade700,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],

//                 const SizedBox(height: 40),

//                 // Verify Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 56,
//                   child: ElevatedButton(
//                     onPressed: _isVerifying ? null : verifyOtp,
//                     style: ElevatedButton.styleFrom(
//                       elevation: 0,
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     child: _isVerifying
//                         ? const SizedBox(
//                             height: 24,
//                             width: 24,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : const Text(
//                             "Verify & Continue",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // Terms and conditions
//                 Text(
//                   "By continuing, you agree to our Terms & Privacy Policy",
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//                   textAlign: TextAlign.center,
//                 ),

//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
