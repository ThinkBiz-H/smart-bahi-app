// // const mongoose = require("mongoose");

// // const billSchema = new mongoose.Schema(
// //   {
// //     mobile: String,

// //     customerName: String,
// //     address: String,

// //     billNumber: String,

// //     date: Date,

// //     items: [
// //       {
// //         name: String,
// //         qty: Number,
// //         rate: Number,
// //         baseAmount: Number,
// //       },
// //     ],

// //     subTotal: Number,
// //     gst: Number,
// //     cess: Number,
// //     charges: Number,
// //     discount: Number,
// //     grandTotal: Number,

// //     paid: Boolean,
// //   },
// //   { timestamps: true },
// // );

// // module.exports = mongoose.model("Bill", billSchema);



// const mongoose = require("mongoose");

// const billSchema = new mongoose.Schema({
//   ownerMobile: String,

//   customerName: String,
//   mobile: String,
//   address: String,

//   billNumber: String,
//   date: Date,

//   items: Array,

//   subTotal: Number,
//   gstTotal: Number,
//   cessTotal: Number,

//   charges: Number,
//   discount: Number,

//   grandTotal: Number,

//   paid: Boolean,
// });

// module.exports = mongoose.model("Bill", billSchema);
const mongoose = require("mongoose");

const billSchema = new mongoose.Schema({

  ownerMobile: String,

  customerName: String,
  mobile: String,
  address: String,

  billNumber: String,
  date: Date,

  items: [
    {
      productCode: String,
      name: String,
      qty: Number,
      rate: Number,
      total: Number
    }
  ],

  subTotal: Number,
  gstTotal: Number,
  cessTotal: Number,

  charges: Number,
  discount: Number,

  grandTotal: Number,

  paid: {
    type: Boolean,
    default: false
  }

}, { timestamps: true });

module.exports = mongoose.model("Bill", billSchema);