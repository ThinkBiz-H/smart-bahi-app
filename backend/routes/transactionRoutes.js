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

const transactionController = require("../controllers/transactionController");

// ADD
router.post("/add", transactionController.addTransaction);

// GET ALL (DATE FILTER)
router.get("/", transactionController.getTransactions);

module.exports = router;
