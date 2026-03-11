// const mongoose = require("mongoose");

// const userSchema = new mongoose.Schema(
//   {
//     mobile: {
//       type: String,
//       required: true,
//       unique: true,
//     },
//     otp: String,
//     otpExpiry: Date,
//   },
//   { timestamps: true },
// );

// module.exports = mongoose.model("User", userSchema);

const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    mobile: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },

    otp: {
      type: Number,
    },

    otpExpiry: {
      type: Date,
    },
  },
  {
    timestamps: true,
  },
);

module.exports = mongoose.model("User", userSchema);
