const express = require("express");
const cors = require("cors");
require("./config/env");
const {connectDB} = require("./config/db");

const app = express();

// Allow CORS from any origin for mobile app access
app.use(cors({
  origin: true,  // Allow any origin
  credentials: true
}));



app.use(express.json());

connectDB();

//app.use("/auth", require("./routes/auth"));
app.use("/bill", require("./routes/bill"));
app.use("/payment", require("./routes/payment"));
app.use("/restaurants", require("./routes/Restaurant"));

// Listen on all interfaces (0.0.0.0) so devices on the network can connect
const HOST = "0.0.0.0";
const PORT = 3000;

app.listen(PORT, HOST, () => {
  console.log(`🚀 Server running on http://${HOST}:${PORT}`);
  console.log("📡 Endpoints:");
  console.log("   - GET  /restaurants/cities");
  console.log("   - GET  /restaurants/city/:citySlug");
  console.log("   - GET  /restaurants/:restaurantId");
  console.log("   - POST /bill/create");
  console.log("   - POST /payment/confirm");
});