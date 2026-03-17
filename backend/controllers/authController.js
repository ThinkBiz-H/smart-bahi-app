// const User = require("../models/User");
// const Device = require("../models/Device");
// const { sendSMS } = require("../services/smsService");
// // ================= SEND OTP =================

// exports.sendOtp = async (req, res) => {
//   try {
//     const { mobile } = req.body;

//     if (!mobile) {
//       return res.json({
//         success: false,
//         message: "Mobile number required",
//       });
//     }

//     let user = await User.findOne({ mobile });

//     if (!user) {
//       user = new User({ mobile });
//     }

//     const otp = Math.floor(100000 + Math.random() * 900000);

//     user.otp = otp;
//     user.otpExpiry = Date.now() + 5 * 60 * 1000;

//     await user.save();

//     console.log("OTP:", otp);

//     /// SEND OTP SMS
//     await sendSMS(mobile, `Your Smart Bahi OTP is ${otp}`);

//     res.json({
//       success: true,
//       message: "OTP sent",
//       mobile,
//     });
//   } catch (error) {
//     console.log("SEND OTP ERROR:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// // ================= VERIFY OTP =================

// exports.verifyOtp = async (req, res) => {
//   try {
//     const { mobile, otp, deviceName, deviceId } = req.body;

//     if (!mobile || !otp) {
//       return res.json({
//         success: false,
//         message: "Mobile and OTP required",
//       });
//     }

//     const user = await User.findOne({ mobile });

//     if (!user) {
//       return res.json({
//         success: false,
//         message: "User not found",
//       });
//     }

//     /// OTP CHECK

//     if (user.otp !== Number(otp)) {
//       return res.json({
//         success: false,
//         message: "Invalid OTP",
//       });
//     }

//     /// OTP EXPIRY

//     if (user.otpExpiry < Date.now()) {
//       return res.json({
//         success: false,
//         message: "OTP expired",
//       });
//     }

//     /// ================= SAVE DEVICE =================

//     if (deviceId) {
//       await Device.findOneAndUpdate(
//         { mobile, deviceId },
//         {
//           mobile,
//           deviceId,
//           deviceName: deviceName || "Unknown Device",
//           lastActive: new Date(),
//         },
//         {
//           upsert: true,
//           new: true,
//         },
//       );
//     }

//     /// CLEAR OTP AFTER LOGIN

//     user.otp = null;
//     user.otpExpiry = null;

//     await user.save();

//     res.json({
//       success: true,
//       message: "Login successful",
//       user,
//     });
//   } catch (error) {
//     console.log("OTP VERIFY ERROR:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// const User = require("../models/User");
// const Device = require("../models/Device");

// // ================= SEND OTP =================

// exports.sendOtp = async (req, res) => {
//   try {
//     const { mobile } = req.body;

//     ```
// if (!mobile) {
//   return res.json({
//     success: false,
//     message: "Mobile number required",
//   });
// }

// let user = await User.findOne({ mobile });

// if (!user) {
//   user = new User({ mobile });
// }

// const otp = Math.floor(100000 + Math.random() * 900000);

// user.otp = otp;
// user.otpExpiry = Date.now() + 5 * 60 * 1000;

// await user.save();

// console.log("OTP:", otp); // 👈 terminal me dikhega

// /// ❌ SMS REMOVE (TEST MODE)

// res.json({
//   success: true,
//   message: "OTP generated (TEST MODE)",
//   mobile,
//   otp, // 👈 frontend me bhi milega
// });
// ```;
//   } catch (error) {
//     console.log("SEND OTP ERROR:", error);

//     ```
// res.status(500).json({
//   success: false,
//   message: error.message,
// });
// ```;
//   }
// };

// // ================= VERIFY OTP =================

// exports.verifyOtp = async (req, res) => {
//   try {
//     const { mobile, otp, deviceName, deviceId } = req.body;

//     if (!mobile || !otp) {
//       return res.json({ success: false, message: "Mobile and OTP required" });
//     }

//     const user = await User.findOne({ mobile });

//     if (!user) {
//       return res.json({ success: false, message: "User not found" });
//     }

//     if (user.otp !== Number(otp)) {
//       return res.json({ success: false, message: "Invalid OTP" });
//     }

//     if (user.otpExpiry < Date.now()) {
//       return res.json({ success: false, message: "OTP expired" });
//     }

//     /// 🔥 MAKE ALL DEVICES NOT CURRENT
//     await Device.updateMany({ mobile }, { isCurrent: false });

//     /// 🔥 SAVE CURRENT DEVICE
//     await Device.findOneAndUpdate(
//       { mobile, deviceId },
//       {
//         mobile,
//         deviceId,
//         deviceName: deviceName || "Unknown Device",
//         isCurrent: true,
//         lastActive: new Date(),
//       },
//       { upsert: true, new: true },
//     );

//     user.otp = null;
//     user.otpExpiry = null;

//     await user.save();

//     res.json({
//       success: true,
//       message: "Login successful",
//       user,
//     });
//   } catch (error) {
//     console.log("OTP VERIFY ERROR:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

const User = require("../models/User");
const Device = require("../models/Device");

// ================= SEND OTP =================

exports.sendOtp = async (req, res) => {
  try {
    const { mobile } = req.body;

    if (!mobile) {
      return res.json({
        success: false,
        message: "Mobile number required",
      });
    }

    let user = await User.findOne({ mobile });

    if (!user) {
      user = new User({ mobile });
    }

    const otp = Math.floor(100000 + Math.random() * 900000);

    user.otp = otp;
    user.otpExpiry = Date.now() + 5 * 60 * 1000;

    await user.save();

    console.log("OTP:", otp);

    res.json({
      success: true,
      message: "OTP generated (TEST MODE)",
      mobile,
      otp,
    });
  } catch (error) {
    console.log("SEND OTP ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// ================= VERIFY OTP =================

exports.verifyOtp = async (req, res) => {
  try {
    let { mobile, otp, deviceName, deviceId } = req.body;

    console.log("DEVICE DATA:", deviceId, deviceName);

    if (!mobile || !otp) {
      return res.json({
        success: false,
        message: "Mobile and OTP required",
      });
    }

    const user = await User.findOne({ mobile });

    if (!user) {
      return res.json({
        success: false,
        message: "User not found",
      });
    }

    if (user.otp !== Number(otp)) {
      return res.json({
        success: false,
        message: "Invalid OTP",
      });
    }

    if (user.otpExpiry < Date.now()) {
      return res.json({
        success: false,
        message: "OTP expired",
      });
    }

    /// ⭐ FIX: deviceId force set
    if (!deviceId) {
      deviceId = "device_" + Date.now();
    }

    if (!deviceName) {
      deviceName = "Android Device";
    }

    /// 🔥 MAKE ALL DEVICES NOT CURRENT
    await Device.updateMany({ mobile }, { isCurrent: false });

    /// 🔥 SAVE CURRENT DEVICE
    await Device.findOneAndUpdate(
      { mobile, deviceId },
      {
        mobile,
        deviceId,
        deviceName,
        isCurrent: true,
        lastActive: new Date(),
      },
      { upsert: true, new: true },
    );

    console.log("DEVICE SAVED ✅");

    user.otp = null;
    user.otpExpiry = null;

    await user.save();

    res.json({
      success: true,
      message: "Login successful",
      user,
    });
  } catch (error) {
    console.log("OTP VERIFY ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
