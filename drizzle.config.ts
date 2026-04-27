import { defineConfig } from "drizzle-kit";

export default defineConfig({
  dialect: "postgresql",
  schema: "./src/db/schema/index.ts",
  out: "./src/db/migrations",

  dbCredentials: {
    // Set DATABASE_URL in .env.local for local dev
    // In production this is injected by Vercel via Terraform
    url: process.env.DATABASE_URL!,
  },

  // Print all SQL statements when running migrations
  verbose: true,

  // Safety check — will not run destructive migrations without confirmation
  strict: true,
});
