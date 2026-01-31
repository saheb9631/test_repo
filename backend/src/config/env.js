const dotenv = require("dotenv");
const path = require("path");

// Get the project root directory (two levels up from src/config/)
const projectRoot = path.resolve(__dirname, "../..");

// Load .env file from project root
dotenv.config({
  path: path.join(projectRoot, ".env")
});

module.exports = {
  projectRoot,
  DATABASE_URL: process.env.DATABASE_URL
};

