// const mongoose = require("mongoose");

// const userSchema = new mongoose.Schema(
//   {
//     mobile: {
//       type: String,
//       required: true,
//       unique: true,
//       trim: true,
//     },

//     otp: {
//       type: Number,
//     },

//     otpExpiry: {
//       type: Date,
//     },
//   },
//   {
//     timestamps: true,
//   },
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

    // 🔥 SUBSCRIPTION ADD
    subscription: {
      plan: {
        type: String,
        default: "free",
      },
      startDate: {
        type: Date,
      },
      endDate: {
        type: Date,
      },
      isActive: {
        type: Boolean,
        default: false,
      },
      dailyLimit: {
        type: Number,
        default: 2, // free user ke liye
      },
    },
  },
  {
    timestamps: true,
  },
);

module.exports = mongoose.model("User", userSchema);
