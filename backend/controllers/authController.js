// const User = require("../models/User");

// exports.sendOtp = async (req, res) => {
//   const { mobile } = req.body;

//   let user = await User.findOne({ mobile });

//   if (!user) {
//     user = new User({ mobile });
//   }

//   const otp = Math.floor(100000 + Math.random() * 900000);

//   user.otp = otp;
//   user.otpExpiry = Date.now() + 5 * 60 * 1000;

//   await user.save();

//   console.log("OTP:", otp);

//   res.json({
//     message: "OTP sent",
//     mobile,
//   });
// };

// exports.verifyOtp = async (req, res) => {
//   const { mobile, otp } = req.body;

//   const user = await User.findOne({ mobile });

//   if (!user) {
//     return res.status(400).json({ message: "User not found" });
//   }

//   if (user.otp !== otp) {
//     return res.status(400).json({ message: "Invalid OTP" });
//   }

//   if (user.otpExpiry < Date.now()) {
//     return res.status(400).json({ message: "OTP expired" });
//   }

//   res.json({
//     message: "Login successful",
//     user,
//   });
// };
// const Device = require("../models/Device");

// exports.verifyOtp = async (req, res) => {
//   const { mobile, deviceName, deviceId } = req.body;

//   await Device.findOneAndUpdate(
//     { deviceId },
//     {
//       mobile,
//       deviceName,
//       lastActive: new Date(),
//     },
//     { upsert: true },
//   );

//   res.json({
//     success: true,
//   });
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
      message: "OTP sent",
      mobile,
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
    const { mobile, otp, deviceName, deviceId } = req.body;

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

    /// OTP CHECK

    if (user.otp !== Number(otp)) {
      return res.json({
        success: false,
        message: "Invalid OTP",
      });
    }

    /// OTP EXPIRY

    if (user.otpExpiry < Date.now()) {
      return res.json({
        success: false,
        message: "OTP expired",
      });
    }

    /// ================= SAVE DEVICE =================

    if (deviceId) {
      await Device.findOneAndUpdate(
        { deviceId },
        {
          mobile,
          deviceName: deviceName || "Unknown Device",
          lastActive: new Date(),
        },
        {
          upsert: true,
          new: true,
        },
      );
    }

    /// CLEAR OTP AFTER LOGIN

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
