// const express = require("express");
// const router = express.Router();

// const {
//   addTransaction,
//   getCustomerTransactions,
// } = require("../controllers/transactionController");

// router.post("/add", addTransaction);
// router.get("/:customerId", getCustomerTransactions);

// module.exports = router;

// aaj ka code hai  //

const express = require("express");
const router = express.Router();

const {
  addTransaction,
  getCustomerTransactions,
  getTransactions, // ✅ add this
} = require("../controllers/transactionController");

// ✅ ADD TRANSACTION
router.post("/add", addTransaction);

// ✅ GET ALL (DATE FILTER)
router.get("/", getTransactions);

// ✅ GET BY CUSTOMER (always LAST me rakho)
router.get("/:customerId", getCustomerTransactions);

module.exports = router;
