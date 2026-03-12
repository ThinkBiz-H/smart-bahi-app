// const Bill = require("../models/Bill");
// const Product = require("../models/Product");

// // exports.createBill = async (req, res) => {
// //   const bill = new Bill(req.body);

// //   await bill.save();

// //   for (const item of req.body.items) {
// //     const product = await Product.findOne({ name: item.name });

// //     if (product) {
// //       product.qty = Number(product.qty) - Number(item.qty);
// //       await product.save();
// //     }
// //   }

// //   res.json(bill);
// // };

// exports.createBill = async (req, res) => {
//   try {
//     const bill = new Bill(req.body);
//     await bill.save();

//     // ensure items is array
//     const items = Array.isArray(req.body.items) ? req.body.items : [];

//     for (const item of items) {
//       const product = await Product.findOne({ name: item.name });

//       if (product) {
//         const currentQty = Number(product.qty) || 0;
//         const sellQty = Number(item.qty) || 0;

//         product.qty = currentQty - sellQty;

//         if (product.qty < 0) product.qty = 0;

//         await product.save();
//       }
//     }

//     res.json(bill);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: err.message });
//   }
// };
// exports.getBills = async (req, res) => {
//   const { mobile } = req.params;

//   const bills = await Bill.find({ mobile });

//   res.json(bills);
// };

// exports.deleteBill = async (req, res) => {
//   const { id } = req.params;

//   await Bill.findByIdAndDelete(id);

//   res.json({ message: "Bill deleted" });
// };

// const Bill = require("../models/Bill");

// /// ADD BILL
// exports.addBill = async (req, res) => {
//   try {
//     const bill = new Bill(req.body);
//     await bill.save();

//     res.json({
//       success: true,
//       data: bill,
//     });
//   } catch (error) {
//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// /// GET BILLS
// exports.getBills = async (req, res) => {
//   try {
//     const mobile = req.params.mobile;

//     const bills = await Bill.find({
//       ownerMobile: mobile,
//     }).sort({ date: -1 });

//     res.json({
//       success: true,
//       data: bills,
//     });
//   } catch (error) {
//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// /// UPDATE BILL
// exports.updateBill = async (req, res) => {
//   try {
//     const id = req.params.id;

//     const bill = await Bill.findByIdAndUpdate(id, req.body, {
//       returnDocument: "after",
//     });

//     res.json({
//       success: true,
//       data: bill,
//     });
//   } catch (error) {
//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// /// DELETE BILL
// exports.deleteBill = async (req, res) => {
//   try {
//     const id = req.params.id;

//     await Bill.findByIdAndDelete(id);

//     res.json({
//       success: true,
//     });
//   } catch (error) {
//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };
// exports.addBill = async (req, res) => {
//   try {
//     console.log("Incoming Bill:", req.body); // ⭐ ADD THIS

//     const bill = new Bill(req.body);
//     await bill.save();

//     res.json({
//       success: true,
//       data: bill,
//     });
//   } catch (error) {
//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };
const Bill = require("../models/Bill");
const Product = require("../models/Product");

/// ADD BILL
exports.addBill = async (req, res) => {
  try {
    const bill = new Bill(req.body);
    await bill.save();

    // ===============================
    // STOCK REDUCE
    // ===============================

    if (req.body.items && req.body.items.length > 0) {
      for (const item of req.body.items) {
        await Product.findOneAndUpdate(
          {
            productCode: item.productCode,
            mobile: req.body.ownerMobile,
          },
          {
            $inc: { qty: -item.qty },
          },
        );
      }
    }

    res.json({
      success: true,
      data: bill,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/// GET BILLS
exports.getBills = async (req, res) => {
  try {
    const mobile = req.params.mobile;

    const bills = await Bill.find({
      ownerMobile: mobile,
    }).sort({ date: -1 });

    res.json({
      success: true,
      data: bills,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/// UPDATE BILL
exports.updateBill = async (req, res) => {
  try {
    const id = req.params.id;

    const bill = await Bill.findByIdAndUpdate(id, req.body, { new: true });

    res.json({
      success: true,
      data: bill,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/// DELETE BILL
exports.deleteBill = async (req, res) => {
  try {
    const id = req.params.id;

    await Bill.findByIdAndDelete(id);

    res.json({
      success: true,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
