const axios = require("axios");

exports.sendPhoneSMS = async (mobile, message) => {
  try {
    await axios.post("http://YOUR_PHONE_IP:3000/send", {
      number: mobile,
      message: message,
    });

    console.log("SMS sent from phone");
  } catch (error) {
    console.log("Phone SMS error:", error.message);
  }
};
