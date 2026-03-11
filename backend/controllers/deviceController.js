const Device = require("../models/Device");

// ================= GET USER DEVICES =================

exports.getDevices = async (req, res) => {
  try {
    const { mobile } = req.params;

    const devices = await Device.find({ mobile }).sort({ lastActive: -1 });

    res.json({
      success: true,
      data: devices,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// ================= LOGOUT DEVICE =================

exports.logoutDevice = async (req, res) => {
  try {
    const { deviceId } = req.body;

    if (!deviceId) {
      return res.json({
        success: false,
        message: "Device ID required",
      });
    }

    const device = await Device.findOneAndDelete({ deviceId });

    if (!device) {
      return res.json({
        success: false,
        message: "Device not found",
      });
    }

    res.json({
      success: true,
      message: "Device logged out successfully",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
