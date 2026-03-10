const User = require("../models/User");

exports.sendOtp = async (req, res) => {
  const { mobile } = req.body;

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
    message: "OTP sent",
    mobile,
  });
};

exports.verifyOtp = async (req, res) => {
  const { mobile, otp } = req.body;

  const user = await User.findOne({ mobile });

  if (!user) {
    return res.status(400).json({ message: "User not found" });
  }

  if (user.otp !== otp) {
    return res.status(400).json({ message: "Invalid OTP" });
  }

  if (user.otpExpiry < Date.now()) {
    return res.status(400).json({ message: "OTP expired" });
  }

  res.json({
    message: "Login successful",
    user,
  });
};
