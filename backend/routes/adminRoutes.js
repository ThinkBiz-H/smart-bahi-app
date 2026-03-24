const express = require("express");
const router = express.Router();
const { getAnalytics } = require("../controllers/adminController");
const {
  getUsers,
  getUser,
  updatePlan,
  toggleUserStatus,
  getDashboard,
  getPayments,
} = require("../controllers/adminController");

router.get("/users", getUsers);
router.get("/user/:id", getUser);
router.post("/update-plan", updatePlan);
router.post("/toggle-user-status", toggleUserStatus);
router.get("/dashboard", getDashboard);
router.get("/payments", getPayments);
router.get("/analytics", getAnalytics);
module.exports = router;
