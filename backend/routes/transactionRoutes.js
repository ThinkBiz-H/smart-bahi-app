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
  getTransactionsByDateRange, // ✅ NEW
} = require("../controllers/transactionController");

// ================= EXISTING ROUTES =================

router.post("/add", addTransaction);
router.get("/:customerId", getCustomerTransactions);

// ================= NEW ROUTE (DATE FILTER) =================

router.post("/by-date", getTransactionsByDateRange);

module.exports = router;
