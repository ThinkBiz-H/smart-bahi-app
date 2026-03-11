        const mongoose = require("mongoose");

        const deviceSchema = new mongoose.Schema(
        {
            mobile: {
            type: String,
            required: true,
            index: true,
            },

            deviceName: {
            type: String,
            default: "Unknown Device",
            },

            deviceId: {
            type: String,
            required: true,
            unique: true,
            },

            location: {
            type: String,
            default: "Unknown",
            },

            lastActive: {
            type: Date,
            default: Date.now,
            },
        },
        {
            timestamps: true,
        },
        );

        module.exports = mongoose.model("Device", deviceSchema);
