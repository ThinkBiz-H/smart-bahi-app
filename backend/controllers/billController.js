// const Bill = require("../models/Bill");
// const Product = require("../models/Product");

// /// ================= ADD BILL =================
// exports.addBill = async (req, res) => {
//   try {
//     const { items, ownerMobile } = req.body;

//     const bill = new Bill(req.body);
//     await bill.save();

//     // ===============================
//     // 🔥 STOCK REDUCE (FULL FIX)
//     // ===============================

//     if (items && items.length > 0) {
//       for (const item of items) {
//         console.log("🧾 ITEM:", item);

//         const product = await Product.findOne({
//           name: item.name, // ✅ productCode hata diya (issue wahi tha)
//           mobile: ownerMobile,
//         });

//         if (!product) {
//           console.log("❌ Product NOT FOUND:", item.name);
//           continue;
//         }

//         const sellQty = Number(item.qty || item.quantity || 0);

//         if (!sellQty || sellQty <= 0) {
//           console.log("⚠️ Invalid qty:", item);
//           continue;
//         }

//         // ❌ STOCK CHECK
//         if (product.qty < sellQty) {
//           return res.status(400).json({
//             success: false,
//             message: `Not enough stock for ${product.name}`,
//           });
//         }

//         // ✅ UPDATE STOCK
//         product.qty = product.qty - sellQty;

//         await product.save();

//         console.log(`✅ STOCK UPDATED: ${product.name} → ${product.qty}`);
//       }
//     }

//     res.json({
//       success: true,
//       message: "Bill created & stock updated",
//       data: bill,
//     });
//   } catch (error) {
//     console.log("❌ BILL ERROR:", error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

// /// ================= GET BILLS =================
// exports.getBills = async (req, res) => {
//   try {
//     const mobile = req.params.mobile;

//     const bills = await Bill.find({
//       ownerMobile: mobile,
//     }).sort({ createdAt: -1 });

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

// /// ================= UPDATE BILL =================
// exports.updateBill = async (req, res) => {
//   try {
//     const id = req.params.id;

//     const bill = await Bill.findByIdAndUpdate(id, req.body, {
//       new: true,
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

// /// ================= DELETE BILL =================
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

const Bill = require("../models/Bill");
const Product = require("../models/Product");
const Customer = require("../models/Customer");
/// ================= ADD BILL =================
exports.addBill = async (req, res) => {
  try {
    const { items, ownerMobile } = req.body;

    const bill = new Bill(req.body);
    await bill.save();

    // ===============================
    // 🔥 STOCK REDUCE (FULL FIX)
    // ===============================

    if (items && items.length > 0) {
      for (const item of items) {
        console.log("🧾 ITEM:", item);

        const product = await Product.findOne({
          name: item.name, // ✅ productCode hata diya (issue wahi tha)
          mobile: ownerMobile,
        });

        if (!product) {
          console.log("❌ Product NOT FOUND:", item.name);
          continue;
        }

        const sellQty = Number(item.qty || item.quantity || 0);

        if (!sellQty || sellQty <= 0) {
          console.log("⚠️ Invalid qty:", item);
          continue;
        }

        // ❌ STOCK CHECK
        if (product.qty < sellQty) {
          return res.status(400).json({
            success: false,
            message: `Not enough stock for ${product.name}`,
          });
        }

        // ✅ UPDATE STOCK
        product.qty = product.qty - sellQty;

        await product.save();

        console.log(`✅ STOCK UPDATED: ${product.name} → ${product.qty}`);
      }
    }

    res.json({
      success: true,
      message: "Bill created & stock updated",
      data: bill,
    });
  } catch (error) {
    console.log("❌ BILL ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/// ================= GET BILLS =================
exports.getBills = async (req, res) => {
  try {
    const mobile = req.params.mobile;

    const bills = await Bill.find({
      ownerMobile: mobile,
    }).sort({ createdAt: -1 });

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

/// ================= UPDATE BILL =================
exports.updateBill = async (req, res) => {
  try {
    const id = req.params.id;

    /// 🔥 OLD BILL
    const oldBill = await Bill.findById(id);

    if (!oldBill) {
      return res.status(404).json({
        success: false,
        message: "Bill not found",
      });
    }

    /// 🔥 UPDATE BILL
    const updatedBill = await Bill.findByIdAndUpdate(id, req.body, {
      new: true,
    });

    /// =====================================
    /// 🔥 CUSTOMER BALANCE LOGIC
    /// =====================================

    const customer = await Customer.findOne({
      mobile: oldBill.mobile,
      name: oldBill.customerName,
    });

    if (customer) {
      /// ❌ unpaid → paid
      if (!oldBill.paid && updatedBill.paid) {
        customer.balance -= oldBill.grandTotal;

        console.log(`💰 PAID: ${customer.name} balance → ${customer.balance}`);
      }

      /// ❌ paid → unpaid (reverse case)
      if (oldBill.paid && !updatedBill.paid) {
        customer.balance += oldBill.grandTotal;

        console.log(
          `⚠️ UNPAID AGAIN: ${customer.name} balance → ${customer.balance}`,
        );
      }

      await customer.save();
    }

    res.json({
      success: true,
      data: updatedBill,
    });
  } catch (error) {
    console.log("❌ UPDATE BILL ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/// ================= DELETE BILL =================
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
