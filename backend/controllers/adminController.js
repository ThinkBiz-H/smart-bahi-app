const User = require("../models/User");
const Bill = require("../models/Bill");

/// 👥 ALL USERS
exports.getUsers = async (req, res) => {
  const users = await User.find().sort({ createdAt: -1 });

  res.json({
    success: true,
    data: users,
  });
};

/// 👤 SINGLE USER
exports.getUser = async (req, res) => {
  const user = await User.findById(req.params.id);

  res.json({
    success: true,
    data: user,
  });
};

/// 🔥 UPDATE PLAN
exports.updatePlan = async (req, res) => {
  const { userId, plan, days, dailyLimit } = req.body;

  const user = await User.findById(userId);

  if (!user) {
    return res.json({ success: false, message: "User not found" });
  }

  const now = new Date();
  const end = user.subscription?.endDate || now;

  const newEnd = new Date(end);
  newEnd.setDate(newEnd.getDate() + Number(days));

  user.subscription = {
    plan,
    startDate: user.subscription?.startDate || now,
    endDate: newEnd,
    dailyLimit,
  };

  await user.save();

  res.json({ success: true });
};

/// 🔒 BLOCK / UNBLOCK
exports.toggleUserStatus = async (req, res) => {
  const { userId } = req.body;

  const user = await User.findById(userId);

  user.status = user.status === "Active" ? "Blocked" : "Active";

  await user.save();

  res.json({ success: true });
};

/// 📊 DASHBOARD
exports.getDashboard = async (req, res) => {
  const totalUsers = await User.countDocuments();
  const activeSubscriptions = await User.countDocuments({
    "subscription.plan": { $ne: "free" },
  });

  const totalBills = await Bill.countDocuments();

  res.json({
    success: true,
    data: {
      totalUsers,
      activeSubscriptions,
      totalBills,
      todayRevenue: 0,
      userGrowth: [],
      dailyBills: [],
      recentActivity: [],
    },
  });
};

/// 💳 PAYMENTS (dummy for now)
exports.getPayments = async (req, res) => {
  res.json({
    success: true,
    data: [],
  });
};

exports.getAnalytics = async (req, res) => {
  try {
    const data = {
      userGrowth: [
        { month: "Jan", users: 10 },
        { month: "Feb", users: 25 },
        { month: "Mar", users: 40 },
      ],
      dailyBills: [
        { day: "Mon", bills: 5 },
        { day: "Tue", bills: 8 },
        { day: "Wed", bills: 6 },
      ],
    };

    res.json({
      success: true,
      data,
    });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};
