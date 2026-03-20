// const express = require("express");
// const router = express.Router();

// const {
//   addTransaction,
//   getCustomerTransactions,
// } = require("../controllers/transactionController");

// router.post("/add", addTransaction);
// router.get("/:customerId", getCustomerTransactions);

// module.exports = router;

const express = require("express");
const router = express.Router();

const {
  addTransaction,
  getCustomerTransactions,
  getTransactionsByDateRange,
} = require("../controllers/transactionController");

// ================= EXISTING =================

router.post("/add", addTransaction);

// ✅ IMPORTANT: ye upar hona chahiye
router.post("/by-date", getTransactionsByDateRange);

// 👇 ye hamesha last me
router.get("/:customerId", getCustomerTransactions);

module.exports = router;
