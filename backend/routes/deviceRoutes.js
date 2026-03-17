const express = require("express");
const router = express.Router();

const { getDevices, logoutDevice } = require("../controllers/deviceController");

/// ================= GET USER DEVICES =================
/// Example: /api/devices/9310727356

router.get("/:mobile", getDevices);

/// ================= LOGOUT DEVICE =================
/// Example: /api/devices/logout

// router.post("/logout", logoutDevice);
router.post("/logout-all", logoutAllDevices);

module.exports = router;
