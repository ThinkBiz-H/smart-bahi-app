const axios = require("axios");

exports.sendSMS = async (mobile, message) => {
  try {
    await axios.post(
      "https://www.fast2sms.com/dev/bulkV2",
      {
        route: "q",
        message: message,
        language: "english",
        numbers: mobile,
      },
      {
        headers: {
          authorization: process.env.SMS_API_KEY,
          "Content-Type": "application/json",
        },
      },
    );

    console.log("SMS sent");
  } catch (error) {
    console.log("SMS error:", error.message);
  }
};
