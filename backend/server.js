// const express = require("express");
// const cors = require("cors");
// const dotenv = require("dotenv");
// const connectDB = require("./config/db");

// // Routes imports
// const authRoutes = require("./routes/authRoutes");
// const customerRoutes = require("./routes/customerRoutes");
// const supplierRoutes = require("./routes/supplierRoutes");
// const billRoutes = require("./routes/billRoutes");
// const reminderRoutes = require("./routes/reminderRoutes");
// const profileRoutes = require("./routes/profileRoutes");
// const productRoutes = require("./routes/productRoutes");
// const transactionRoutes = require("./routes/transactionRoutes");

// // Configuration
// dotenv.config();

// // Database connection
// connectDB();

// const app = express();

// // Middleware
// app.use(
//   cors({
//     origin: process.env.CLIENT_URL || "*",
//     credentials: true,
//   }),
// );
// app.use(express.json());
// app.use(express.urlencoded({ extended: true }));
// app.use("/api/bills", billRoutes);

// // API Routes
// const apiRoutes = {
//   "/api/auth": authRoutes,
//   "/api/customers": customerRoutes,
//   "/api/suppliers": supplierRoutes,
//   "/api/bills": billRoutes,
//   "/api/reminders": reminderRoutes,
//   "/api/profile": profileRoutes,
//   "/api/products": productRoutes,
//   "/api/transactions": transactionRoutes,
// };

// // Register routes dynamically
// Object.entries(apiRoutes).forEach(([path, route]) => {
//   app.use(path, route);
// });

// // Health check endpoint
// app.get("/health", (req, res) => {
//   res.status(200).json({
//     status: "OK",
//     timestamp: new Date().toISOString(),
//     uptime: process.uptime(),
//     environment: process.env.NODE_ENV || "development",
//   });
// });

// // 404 handler
// app.use((req, res) => {
//   res.status(404).json({
//     success: false,
//     message: "Route not found",
//   });
// });

// // Error handling middleware
// app.use((err, req, res, next) => {
//   console.error("❌ Error:", err.stack);
//   res.status(err.status || 500).json({
//     success: false,
//     message: err.message || "Internal server error",
//     ...(process.env.NODE_ENV === "development" && { stack: err.stack }),
//   });
// });

// const PORT = process.env.PORT || 5000;
// const HOST = process.env.HOST || "localhost";

// const server = app.listen(PORT, () => {
//   const env = process.env.NODE_ENV || "development";
//   const baseUrl = `http://${HOST}:${PORT}`;
//   const timestamp = new Date().toLocaleString("en-IN", {
//     timeZone: "Asia/Kolkata",
//     dateStyle: "full",
//     timeStyle: "medium",
//   });

//   console.log("\n" + "=".repeat(60));
//   console.log(`
//   🚀  SERVER IS RUNNING SUCCESSFULLY
//   `);
//   console.log("=".repeat(60));
//   console.log(`
//   📊  Environment  : ${env === "production" ? "🌍 PRODUCTION" : "💻 DEVELOPMENT"}
//   📡  Address      : ${baseUrl}
//   🔌  Port         : ${PORT}
//   🗄️   Database     : ${process.env.MONGO_URI ? "✅ Connected" : "❌ Not Connected"}
//   📝  Routes Loaded: ${Object.keys(apiRoutes).length}
//   ⏰  Started At   : ${timestamp}
//   `);

//   // Available Routes
//   console.log("📋  Available Endpoints:");
//   Object.keys(apiRoutes).forEach((path) => {
//     console.log(`     └─ ${path.padEnd(20)} → ${baseUrl}${path}`);
//   });

//   console.log("\n" + "=".repeat(60));
//   console.log("✨  Server is ready to accept connections\n");
// });

// // Graceful shutdown handling
// const gracefulShutdown = (signal) => {
//   console.log(`\n👋 Received ${signal}. Starting graceful shutdown...`);

//   server.close(() => {
//     console.log("✅ HTTP server closed.");

//     // Close database connection if needed
//     // mongoose.connection.close(false, () => {
//     //   console.log('✅ MongoDB connection closed.');
//     //   process.exit(0);
//     // });

//     process.exit(0);
//   });

//   // Force shutdown after 10 seconds
//   setTimeout(() => {
//     console.error(
//       "❌ Could not close connections in time, forcefully shutting down",
//     );
//     process.exit(1);
//   }, 10000);
// };

// process.on("SIGTERM", () => gracefulShutdown("SIGTERM"));
// process.on("SIGINT", () => gracefulShutdown("SIGINT"));

// // Handle uncaught exceptions
// process.on("uncaughtException", (error) => {
//   console.error("❌ Uncaught Exception:", error);
//   gracefulShutdown("UNCAUGHT EXCEPTION");
// });

// process.on("unhandledRejection", (reason, promise) => {
//   console.error("❌ Unhandled Rejection at:", promise, "reason:", reason);
// });

// module.exports = { app, server };

const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const connectDB = require("./config/db");

// Routes imports
const authRoutes = require("./routes/authRoutes");
const customerRoutes = require("./routes/customerRoutes");
const supplierRoutes = require("./routes/supplierRoutes");
const billRoutes = require("./routes/billRoutes");
const reminderRoutes = require("./routes/reminderRoutes");
const profileRoutes = require("./routes/profileRoutes");
const productRoutes = require("./routes/productRoutes");
const transactionRoutes = require("./routes/transactionRoutes");

// Load env
dotenv.config();

// Connect database
connectDB();

const app = express();

// Middleware
app.use(
  cors({
    origin: process.env.CLIENT_URL || "*",
    credentials: true,
  }),
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ================= DEVICES ROUTE =================
app.use("/api/devices", require("./routes/deviceRoutes"));

// ================= API ROUTES =================

const apiRoutes = {
  "/api/auth": authRoutes,
  "/api/customers": customerRoutes,
  "/api/suppliers": supplierRoutes,
  "/api/bills": billRoutes,
  "/api/reminders": reminderRoutes,
  "/api/profile": profileRoutes,
  "/api/products": productRoutes,
  "/api/transactions": transactionRoutes,
};

// Register routes dynamically
Object.entries(apiRoutes).forEach(([path, route]) => {
  app.use(path, route);
});

// ================= HEALTH CHECK =================

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "OK",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || "development",
  });
});

// ================= 404 HANDLER =================

app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "Route not found",
  });
});

// ================= ERROR HANDLER =================

app.use((err, req, res, next) => {
  console.error("❌ Error:", err.stack);

  res.status(err.status || 500).json({
    success: false,
    message: err.message || "Internal server error",
    ...(process.env.NODE_ENV === "development" && { stack: err.stack }),
  });
});

// ================= SERVER START =================

const PORT = process.env.PORT || 5000;
const HOST = process.env.HOST || "localhost";

const server = app.listen(PORT, () => {
  const env = process.env.NODE_ENV || "development";
  const baseUrl = `http://${HOST}:${PORT}`;

  const timestamp = new Date().toLocaleString("en-IN", {
    timeZone: "Asia/Kolkata",
    dateStyle: "full",
    timeStyle: "medium",
  });

  console.log("\n" + "=".repeat(60));
  console.log(`
  🚀  SERVER IS RUNNING SUCCESSFULLY
  `);
  console.log("=".repeat(60));

  console.log(`
  📊  Environment  : ${env === "production" ? "🌍 PRODUCTION" : "💻 DEVELOPMENT"}
  📡  Address      : ${baseUrl}
  🔌  Port         : ${PORT}
  🗄️   Database     : ${process.env.MONGO_URI ? "✅ Connected" : "❌ Not Connected"}
  📝  Routes Loaded: ${Object.keys(apiRoutes).length}
  ⏰  Started At   : ${timestamp}
  `);

  console.log("📋  Available Endpoints:");
  Object.keys(apiRoutes).forEach((path) => {
    console.log(`     └─ ${path.padEnd(20)} → ${baseUrl}${path}`);
  });

  console.log("\n" + "=".repeat(60));
  console.log("✨  Server is ready to accept connections\n");
});

// ================= GRACEFUL SHUTDOWN =================

const gracefulShutdown = (signal) => {
  console.log(`\n👋 Received ${signal}. Starting graceful shutdown...`);

  server.close(() => {
    console.log("✅ HTTP server closed.");
    process.exit(0);
  });

  setTimeout(() => {
    console.error(
      "❌ Could not close connections in time, forcefully shutting down",
    );
    process.exit(1);
  }, 10000);
};

process.on("SIGTERM", () => gracefulShutdown("SIGTERM"));
process.on("SIGINT", () => gracefulShutdown("SIGINT"));

process.on("uncaughtException", (error) => {
  console.error("❌ Uncaught Exception:", error);
  gracefulShutdown("UNCAUGHT EXCEPTION");
});

process.on("unhandledRejection", (reason, promise) => {
  console.error("❌ Unhandled Rejection at:", promise, "reason:", reason);
});

module.exports = { app, server };
