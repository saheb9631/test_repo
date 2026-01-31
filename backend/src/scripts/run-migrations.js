const fs = require("fs");
const path = require("path");
const { Pool } = require("pg");

// Load .env from src/ folder
const dotenv = require("dotenv");
const envPath = path.resolve(__dirname, "../.env");
dotenv.config({ path: envPath });

const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

async function runMigrations() {
  const client = await pool.connect();
  
  try {
    console.log("📦 Running migrations...\n");
    
    // Read and execute 001_initial_schema.sql
    const schema1Path = path.join(__dirname, "../../migrations/001_initial_schema.sql");
    const schema1 = fs.readFileSync(schema1Path, "utf-8");
    
    console.log("Running 001_initial_schema.sql...");
    await client.query(schema1);
    console.log("✓ Migration 001 completed\n");
    
    // Read and execute 002_add_restaurants.sql
    const schema2Path = path.join(__dirname, "../../migrations/002_add_restaurants.sql");
    const schema2 = fs.readFileSync(schema2Path, "utf-8");
    
    console.log("Running 002_add_restaurants.sql...");
    await client.query(schema2);
    console.log("✓ Migration 002 completed\n");
    
    console.log("✅ All migrations completed successfully!");
    
  } catch (err) {
    console.error("❌ Migration error:", err.message);
    throw err;
  } finally {
    client.release();
    await pool.end();
  }
}

runMigrations()
  .then(() => process.exit(0))
  .catch(() => process.exit(1));

