// const Transaction = require("../models/Transaction");
// const Customer = require("../models/Customer");
// const { sendPhoneSMS } = require("../services/phoneSMSService");

// /// ================= ADD TRANSACTION =================

// exports.addTransaction = async (req, res) => {
//   try {
//     const { ownerMobile, customerId, type, amount, note } = req.body;

//     /// ================= VALIDATION =================

//     if (!ownerMobile || !customerId || !type || !amount) {
//       return res.status(400).json({
//         success: false,
//         message: "Required fields missing",
//       });
//     }

//     /// ================= CREATE TRANSACTION =================

//     const transaction = new Transaction({
//       ownerMobile,
//       customerId,
//       type,
//       amount,
//       note,
//     });

//     await transaction.save();

//     /// ================= FETCH CUSTOMER =================

//     const customer = await Customer.findById(customerId);

//     /// ================= SEND SMS =================

//     if (customer && customer.mobile) {
//       let message = "";

//       if (type === "credit") {
//         message = `₹${amount} received from ${customer.name}. Thank you! - Smart Bahi`;
//       } else {
//         message = `₹${amount} added to your account. - Smart Bahi`;
//       }

//       await sendPhoneSMS(customer.mobile, message);
//     }

//     /// ================= RESPONSE =================

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

// aaj ka code hai //
const Transaction = require("../models/Transaction");
const Customer = require("../models/Customer");
const { sendPhoneSMS } = require("../services/phoneSMSService");

/// ================= ADD TRANSACTION =================

exports.addTransaction = async (req, res) => {
  try {
    const { ownerMobile, customerId, type, amount, note } = req.body;

    if (!ownerMobile || !customerId || !type || !amount) {
      return res.status(400).json({
        success: false,
        message: "Required fields missing",
      });
    }

    const transaction = new Transaction({
      ownerMobile,
      customerId,
      type,
      amount,
      note,
    });

    await transaction.save();

    const customer = await Customer.findById(customerId);

    if (customer && customer.mobile) {
      let message = "";

      if (type === "credit") {
        message = `₹${amount} received from ${customer.name}. Thank you! - Smart Bahi`;
      } else {
        message = `₹${amount} added to your account. - Smart Bahi`;
      }

      await sendPhoneSMS(customer.mobile, message);
    }

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

/// ================= GET ALL TRANSACTIONS (DATE FILTER) =================

exports.getTransactions = async (req, res) => {
  try {
    const { startDate, endDate } = req.query;

    let filter = {};

    // ✅ DATE FILTER
    if (startDate && endDate) {
      filter.createdAt = {
        $gte: new Date(startDate),
        $lte: new Date(endDate + "T23:59:59.999Z"),
      };
    }

    const transactions = await Transaction.find(filter).sort({
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

/// ================= GET CUSTOMER TRANSACTIONS =================

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
const mongoose = require("mongoose");

exports.getTransactions = async (req, res) => {
  try {
    const { startDate, endDate, customerId } = req.query;

    let filter = {};

    // ✅ CUSTOMER FILTER (MAIN FIX 🔥)
    if (customerId) {
      filter.customerId = new mongoose.Types.ObjectId(customerId);
    }

    // ✅ DATE FILTER
    if (startDate && endDate) {
      filter.createdAt = {
        $gte: new Date(startDate + "T00:00:00.000Z"),
        $lte: new Date(endDate + "T23:59:59.999Z"),
      };
    }

    const transactions = await Transaction.find(filter).sort({
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
