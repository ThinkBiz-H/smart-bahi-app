// const User = require("../models/User");
// const Device = require("../models/Device");

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

//     res.json({
//       success: true,
//       message: "OTP generated (TEST MODE)",
//       mobile,
//       otp,
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
//     let { mobile, otp, deviceName, deviceId } = req.body;

//     console.log("DEVICE DATA:", deviceId, deviceName);

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

//     if (user.otp !== Number(otp)) {
//       return res.json({
//         success: false,
//         message: "Invalid OTP",
//       });
//     }

//     if (user.otpExpiry < Date.now()) {
//       return res.json({
//         success: false,
//         message: "OTP expired",
//       });
//     }

//     /// ⭐ FIX: deviceId force set
//     if (!deviceId) {
//       deviceId = "device_" + Date.now();
//     }

//     if (!deviceName) {
//       deviceName = "Android Device";
//     }

//     /// 🔥 MAKE ALL DEVICES NOT CURRENT
//     await Device.updateMany({ mobile }, { isCurrent: false });

//     /// 🔥 SAVE CURRENT DEVICE
//     await Device.findOneAndUpdate(
//       { mobile, deviceId },
//       {
//         mobile,
//         deviceId,
//         deviceName,
//         isCurrent: true,
//         lastActive: new Date(),
//       },
//       { upsert: true, new: true },
//     );

//     console.log("DEVICE SAVED ✅");

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
// exports.logoutAllDevices = async (req, res) => {
//   try {
//     const { mobile } = req.body;

//     if (!mobile) {
//       return res.json({
//         success: false,
//         message: "Mobile required",
//       });
//     }

//     await Device.deleteMany({ mobile });

//     res.json({
//       success: true,
//       message: "All devices logged out",
//     });
//   } catch (error) {
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

// exports.verifyOtp = async (req, res) => {
//   try {
//     let { mobile, otp, deviceName } = req.body;

//     console.log("VERIFY OTP REQUEST");

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

//     if (user.otp !== Number(otp)) {
//       return res.json({
//         success: false,
//         message: "Invalid OTP",
//       });
//     }

//     if (user.otpExpiry < Date.now()) {
//       return res.json({
//         success: false,
//         message: "OTP expired",
//       });
//     }

//     /// 🔥 DEFAULT DEVICE NAME
//     if (!deviceName) {
//       deviceName = "Android Device";
//     }

//     /// 🔥 FIX: REMOVE deviceId COMPLETELY (NO DUPLICATE ERROR)
//     await Device.updateMany({ mobile }, { isCurrent: false });

//     await Device.findOneAndUpdate(
//       { mobile }, // ✅ ONLY MOBILE
//       {
//         mobile,
//         deviceName,
//         isCurrent: true,
//         lastActive: new Date(),
//       },
//       // { upsert: true, new: true },
//       { upsert: true, returnDocument: "after" },
//     );

//     console.log("DEVICE SAVED ✅");

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

exports.verifyOtp = async (req, res) => {
  try {
    let { mobile, otp, deviceName, deviceId } = req.body;

    if (!mobile || !otp) {
      return res.json({
        success: false,
        message: "Mobile and OTP required",
      });
    }

    if (!deviceId) {
      return res.json({
        success: false,
        message: "Device ID required",
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

    if (!deviceName) {
      deviceName = "Android Device";
    }

    // ✅ important
    await Device.updateMany({ mobile }, { isCurrent: false });

    await Device.findOneAndUpdate(
      { mobile, deviceId }, // ✅ FIX
      {
        mobile,
        deviceName,
        deviceId,
        isCurrent: true,
        lastActive: new Date(),
      },
      { upsert: true, new: true },
    );

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

// ================= LOGOUT =================

exports.logoutAllDevices = async (req, res) => {
  try {
    const { mobile } = req.body;

    if (!mobile) {
      return res.json({
        success: false,
        message: "Mobile required",
      });
    }

    await Device.deleteMany({ mobile });

    res.json({
      success: true,
      message: "All devices logged out",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
