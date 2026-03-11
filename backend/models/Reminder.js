const mongoose = require("mongoose");

const reminderSchema = new mongoose.Schema(
  {
    ownerMobile: {
      type: String,
      required: true,
    },

    customerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Customer",
    },

    message: {
      type: String,
      default: "",
    },

    date: {
      type: Date,
      required: true,
    },
  },
  {
    timestamps: true,
  },
);

module.exports = mongoose.model("Reminder", reminderSchema);
