// const express = require("express");

// const router = express.Router();

// const {
//   addTransaction,
//   getTransactions,
// } = require("../controllers/transactionController");

// router.post("/", addTransaction);

// router.get("/:mobile/:customerName", getTransactions);

// module.exports = router;

const express = require("express");
const router = express.Router();

const {
  addTransaction,
  getCustomerTransactions,
} = require("../controllers/transactionController");

router.post("/add", addTransaction);
router.get("/:customerId", getCustomerTransactions);

module.exports = router;
