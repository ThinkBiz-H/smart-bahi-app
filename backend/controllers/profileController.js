const Profile = require("../models/Profile");

exports.saveProfile = async (req, res) => {
  const { mobile } = req.body;

  let profile = await Profile.findOne({ mobile });

  if (!profile) {
    profile = new Profile(req.body);
  } else {
    Object.assign(profile, req.body);
  }

  await profile.save();

  res.json(profile);
};

exports.getProfile = async (req, res) => {
  const { mobile } = req.params;

  const profile = await Profile.findOne({ mobile });

  res.json(profile);
};
