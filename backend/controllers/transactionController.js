// const Transaction = require("../models/Transaction");

// /// ================= ADD TRANSACTION =================

// exports.addTransaction = async (req, res) => {
//   try {
//     const { ownerMobile, customerId, type, amount, note } = req.body;

//     /// VALIDATION
//     if (!ownerMobile || !customerId || !type || !amount) {
//       return res.status(400).json({
//         success: false,
//         message: "Required fields missing",
//       });
//     }

//     const transaction = new Transaction({
//       ownerMobile,
//       customerId,
//       type,
//       amount,
//       note,
//     });

//     await transaction.save();

//     res.status(200).json({
//       success: true,
//       data: transaction,
//       message: "Transaction saved successfully",
//     });
//   } catch (error) {
//     console.error("Transaction Error:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// /// ================= GET CUSTOMER TRANSACTIONS =================

// exports.getCustomerTransactions = async (req, res) => {
//   try {
//     const { customerId } = req.params;

//     if (!customerId) {
//       return res.status(400).json({
//         success: false,
//         message: "Customer ID required",
//       });
//     }

//     const transactions = await Transaction.find({ customerId }).sort({
//       createdAt: -1,
//     });

//     res.status(200).json({
//       success: true,
//       count: transactions.length,
//       data: transactions,
//     });
//   } catch (error) {
//     console.error("Fetch Transaction Error:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

const Transaction = require("../models/Transaction");
const Customer = require("../models/Customer");
const { sendPhoneSMS } = require("../services/phoneSMSService");

/// ================= ADD TRANSACTION =================

exports.addTransaction = async (req, res) => {
  try {
    const { ownerMobile, customerId, type, amount, note } = req.body;

    /// ================= VALIDATION =================

    if (!ownerMobile || !customerId || !type || !amount) {
      return res.status(400).json({
        success: false,
        message: "Required fields missing",
      });
    }

    /// ================= CREATE TRANSACTION =================

    const transaction = new Transaction({
      ownerMobile,
      customerId,
      type,
      amount,
      note,
    });

    await transaction.save();

    /// ================= FETCH CUSTOMER =================

    const customer = await Customer.findById(customerId);

    /// ================= SEND SMS =================

    if (customer && customer.mobile) {
      let message = "";

      if (type === "credit") {
        message = `₹${amount} received from ${customer.name}. Thank you! - Smart Bahi`;
      } else {
        message = `₹${amount} added to your account. - Smart Bahi`;
      }

      await sendPhoneSMS(customer.mobile, message);
    }

    /// ================= RESPONSE =================

    res.status(200).json({
      success: true,
      data: transaction,
      message: "Transaction saved successfully",
    });
  } catch (error) {
    console.error("Transaction Error:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/// ================= GET CUSTOMER TRANSACTIONS =================

exports.getCustomerTransactions = async (req, res) => {
  try {
    const { customerId } = req.params;

    if (!customerId) {
      return res.status(400).json({
        success: false,
        message: "Customer ID required",
      });
    }

    const transactions = await Transaction.find({ customerId }).sort({
      createdAt: -1,
    });

    res.status(200).json({
      success: true,
      count: transactions.length,
      data: transactions,
    });
  } catch (error) {
    console.error("Fetch Transaction Error:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
